import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/safeband_data.dart';
import '../../widgets/sensor_simulation_badge.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Safety Reports',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.safetyAccent),
            tooltip: 'Export Shift PDF Report',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Shift Safety Compliance Audit Report exported.'),
                  backgroundColor: AppColors.safe,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simulation Mode Notice Banner
              const SensorSimulationBadge(),
              const SizedBox(height: 8),

              // Workforce Status Breakdown Card (Total Workers: 12, Safe: 10, Warning: 1, Danger: 1)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'WORKFORCE SAFETY ROSTER',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 1.0),
                        ),
                        Text(
                          'Active Shift (12 Workers)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.safetyAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: const [
                        Expanded(child: _ReportMetric(label: 'Total Workers', count: '12', color: AppColors.primaryText)),
                        Expanded(child: _ReportMetric(label: 'Safe', count: '10', color: AppColors.safe)),
                        Expanded(child: _ReportMetric(label: 'Warning', count: '1', color: AppColors.warning)),
                        Expanded(child: _ReportMetric(label: 'Danger', count: '1', color: AppColors.danger)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Environmental Telemetry Data Card (CO 0 ppm, H2S 0 ppm, Temp 0 °C, Humidity 0 %)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'ENVIRONMENTAL DATA (SIMULATION)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 1.0),
                        ),
                        SensorSimulationBadge(compact: true),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      SafeBandData.simulationDisclaimer,
                      style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: const [
                        Expanded(child: _EnvTile(label: 'CO', val: '0 ppm', sub: 'Carbon Monoxide', icon: Icons.air_rounded)),
                        SizedBox(width: 8),
                        Expanded(child: _EnvTile(label: 'H₂S', val: '0 ppm', sub: 'Hydrogen Sulfide', icon: Icons.science_outlined)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Expanded(child: _EnvTile(label: 'Temperature', val: '0 °C', sub: 'Ambient Temperature', icon: Icons.thermostat_rounded)),
                        SizedBox(width: 8),
                        Expanded(child: _EnvTile(label: 'Humidity', val: '0 %', sub: 'Relative Humidity', icon: Icons.water_drop_outlined)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Incident & Compliance Audit Table
              const Text(
                'SHIFT AUDIT LOG',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 1.0),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _auditRow('Active Shift Danger Incidents', '1 Flagged (Suresh - Area B)', AppColors.danger),
                    const Divider(height: 16, color: AppColors.border),
                    _auditRow('Environmental Warnings', '1 Flagged (Karthik - Storage)', AppColors.warning),
                    const Divider(height: 16, color: AppColors.border),
                    _auditRow('Hardware Telemetry Integrity', 'Simulation Mode (Zero Mock)', AppColors.secondaryText),
                    const Divider(height: 16, color: AppColors.border),
                    _auditRow('OSHA / Safety Regulation Compliance', '100% Monitored', AppColors.safe),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _auditRow(String title, String val, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText))),
        Text(val, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _ReportMetric extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _ReportMetric({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

class _EnvTile extends StatelessWidget {
  final String label;
  final String val;
  final String sub;
  final IconData icon;

  const _EnvTile({required this.label, required this.val, required this.sub, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.safetyAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primaryText)),
                Text(sub, style: const TextStyle(fontSize: 9, color: AppColors.disabledText), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
