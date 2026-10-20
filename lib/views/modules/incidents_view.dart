import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/status_badge.dart';

class IncidentsView extends StatelessWidget {
  const IncidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardProvider>(context);
    final incidents = dashProvider.incidents;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Incident Reports',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Investigated industrial events, hazard logs & safety audits',
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.note_add_outlined, size: 18),
                label: const Text('REPORT INCIDENT'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (incidents.isEmpty) ...[
            const EmptyStateCard(
              icon: Icons.assignment_turned_in_outlined,
              title: 'No incidents reported',
              description: 'Zero active industrial safety incidents currently under investigation.',
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final inc = incidents[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.assignment_late_outlined, color: AppColors.warning),
                    title: Text('${inc.incidentCode} — ${inc.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${inc.zone} • Reported by ${inc.reportedBy}'),
                    trailing: StatusBadge(status: inc.status),
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
