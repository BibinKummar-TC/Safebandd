import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/safeband_data.dart';
import '../../widgets/sensor_simulation_badge.dart';

class DeviceStatusView extends StatefulWidget {
  const DeviceStatusView({super.key});

  @override
  State<DeviceStatusView> createState() => _DeviceStatusViewState();
}

class _DeviceStatusViewState extends State<DeviceStatusView> {
  bool _isScanning = false;

  void _scanDevices() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No physical SafeBand hardware found nearby. Operating in Simulation Mode.'),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

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
          'Device Status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hardware Simulation Banner
              const SensorSimulationBadge(),
              const SizedBox(height: 10),

              // SafeBand Watch Primary Status Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.safetyAccent),
                          ),
                          child: const Icon(Icons.watch_rounded, size: 28, color: AppColors.safetyAccent),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'SafeBand Watch',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryText),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppColors.warning),
                                    ),
                                    child: const Text(
                                      'Simulation Mode',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.warning),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text('Model: SafeBand Enterprise V2', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                              const SizedBox(height: 2),
                              Row(
                                children: const [
                                  Icon(Icons.circle, size: 8, color: AppColors.danger),
                                  SizedBox(width: 6),
                                  Text(
                                    'Status: Not Connected',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.danger),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 14),

                    // Metrics Row: Battery, Connection, Mode
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _StatusMetric(label: 'Battery', val: '0 %', icon: Icons.battery_0_bar_rounded),
                        _StatusMetric(label: 'Connection', val: 'Not Connected', icon: Icons.bluetooth_disabled_rounded),
                        _StatusMetric(label: 'Mode', val: 'Simulation', icon: Icons.sensors_off_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Sensor Telemetry Diagnostic Status Checklist (All Disconnected / Zero)
              const Text(
                'SENSOR HEALTH DIAGNOSTICS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 1.0),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _diagnosticRow(
                      sensor: 'CO Gas Sensor (MQ-7)',
                      reading: '0 ppm',
                      status: 'Disconnected (Simulation)',
                      icon: Icons.air_rounded,
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _diagnosticRow(
                      sensor: 'H₂S Gas Sensor (MQ-136)',
                      reading: '0 ppm',
                      status: 'Disconnected (Simulation)',
                      icon: Icons.science_outlined,
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _diagnosticRow(
                      sensor: 'Temperature Probe (DS18B20)',
                      reading: '0 °C',
                      status: 'Disconnected (Simulation)',
                      icon: Icons.thermostat_rounded,
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _diagnosticRow(
                      sensor: 'Humidity Sensor (DHT22)',
                      reading: '0 %',
                      status: 'Disconnected (Simulation)',
                      icon: Icons.water_drop_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Scan for Bluetooth Device Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.safetyAccent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: _isScanning
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                        )
                      : const Icon(Icons.bluetooth_searching_rounded, size: 20),
                  label: Text(
                    _isScanning ? 'SEARCHING FOR SAFEBAND BLE...' : 'SCAN FOR PHYSICAL SAFEBAND',
                    style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                  onPressed: _isScanning ? null : _scanDevices,
                ),
              ),
              const SizedBox(height: 14),

              // Hardware Connection Note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: AppColors.secondaryText),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        SafeBandData.simulationDisclaimer,
                        style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _diagnosticRow({
    required String sensor,
    required String reading,
    required String status,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.secondaryText),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sensor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                const SizedBox(height: 2),
                Text(status, style: const TextStyle(fontSize: 11, color: AppColors.disabledText)),
              ],
            ),
          ),
          Text(
            reading,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}

class _StatusMetric extends StatelessWidget {
  final String label;
  final String val;
  final IconData icon;

  const _StatusMetric({required this.label, required this.val, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.secondaryText),
        const SizedBox(height: 6),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
      ],
    );
  }
}
