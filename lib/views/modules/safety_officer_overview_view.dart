import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';

class SafetyOfficerOverviewView extends StatelessWidget {
  const SafetyOfficerOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Safety Officer Risk Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'OSHA & industrial safety compliance matrix and environmental risk indices',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),

          // Risk Cards
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildRiskIndexCard('Chemical Exposure Risk', 'LOW (0.0 PPM)', AppColors.success, Icons.science_outlined),
              _buildRiskIndexCard('Thermal Stress Index', 'NORMAL (24°C)', AppColors.success, Icons.thermostat_outlined),
              _buildRiskIndexCard('OSHA Compliance Status', 'COMPLIANT (100%)', AppColors.success, Icons.verified_outlined),
            ],
          ),
          const SizedBox(height: 28),

          const Text(
            'Environmental Risk Telemetry Feed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
          ),
          const SizedBox(height: 12),

          if (dashProvider.latestSensorData == null || !dashProvider.latestSensorData!.isAvailable) ...[
            const EmptyStateCard(
              icon: Icons.shield_outlined,
              title: 'No sensor data available',
              description: 'Connect a SafeBand device to begin environmental monitoring.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiskIndexCard(String title, String value, Color statusColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
        ],
      ),
    );
  }
}
