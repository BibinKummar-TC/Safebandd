import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/status_badge.dart';

class ZonesView extends StatelessWidget {
  const ZonesView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardProvider>(context);
    final zones = dashProvider.zones;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Industrial Hazard Zones',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Facility sector definitions, risk classification & active personnel counts',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),

          if (zones.isEmpty) ...[
            const EmptyStateCard(
              icon: Icons.map_outlined,
              title: 'No active hazard zones registered',
              description: 'Zone configurations will appear here once defined in the database.',
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: zones.length,
              itemBuilder: (context, index) {
                final zone = zones[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.location_on_outlined, color: AppColors.safetyAccent),
                    title: Text(
                      zone['name']?.toString() ?? 'Industrial Zone',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
                    ),
                    subtitle: Text(
                      zone['description']?.toString() ?? 'Facility area',
                      style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
                    ),
                    trailing: StatusBadge(status: zone['risk_level']?.toString() ?? 'NORMAL'),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
