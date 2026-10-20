import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';

class SupervisorOverviewView extends StatelessWidget {
  const SupervisorOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardProvider>(context);
    final workerCount = dashProvider.allWorkers.length;
    final alerts = dashProvider.alerts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Supervisor Operational Command',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Active shift worker status, zone occupancy & facility environmental monitoring',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),

          // Overview Stats
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard('Active Shift Personnel', '$workerCount Workers', Icons.people_outline_rounded, AppColors.success),
              _buildStatCard('Active Hazard Zones', '${dashProvider.zones.length} Zones', Icons.map_outlined, AppColors.safetyAccent),
              _buildStatCard('Active Safety Alerts', '${alerts.length} Triggered', Icons.warning_amber_rounded, alerts.isEmpty ? AppColors.success : AppColors.highRisk),
              _buildStatCard('Hardware Fleet', '${dashProvider.devices.length} Paired', Icons.watch_outlined, AppColors.secondaryText),
            ],
          ),
          const SizedBox(height: 28),

          // Environmental Telemetry Feed / Empty State
          const Text(
            'Zone Environmental Monitoring Feed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
          ),
          const SizedBox(height: 12),

          if (dashProvider.latestSensorData == null || !dashProvider.latestSensorData!.isAvailable) ...[
            const EmptyStateCard(
              icon: Icons.sensors_off_rounded,
              title: 'No sensor data available',
              description: 'Connect a SafeBand device to begin environmental monitoring.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
              Icon(icon, size: 20, color: accentColor),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryText, letterSpacing: -0.5),
          ),
        ],
      ),
    );
  }
}
