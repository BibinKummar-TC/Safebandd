import 'package:flutter/material.dart';
import '../../config/constants.dart';
import 'supervisor_dashboard_view.dart';
import 'live_map_view.dart';
import 'worker_details_view.dart';
import 'alerts_view.dart';
import 'workers_list_view.dart';
import 'emergency_contacts_view.dart';
import 'geofence_view.dart';
import 'device_status_view.dart';
import 'message_worker_view.dart';
import 'plant_areas_view.dart';
import 'reports_view.dart';
import 'profile_view.dart';
import 'more_view.dart';

class ScreenShowcaseView extends StatefulWidget {
  const ScreenShowcaseView({super.key});

  @override
  State<ScreenShowcaseView> createState() => _ScreenShowcaseViewState();
}

class _ScreenShowcaseViewState extends State<ScreenShowcaseView> {
  int _gridColumns = 3;

  final List<Map<String, dynamic>> _screens = [
    {'title': '01. Supervisor Dashboard', 'widget': const SupervisorDashboardView()},
    {'title': '02. Live Map & Danger Worker Pin', 'widget': const LiveMapView()},
    {'title': '03. Worker Details (Suresh)', 'widget': const WorkerDetailsView(workerName: 'Suresh')},
    {'title': '04. Safety Alerts Log', 'widget': const AlertsView()},
    {'title': '05. Workers Directory', 'widget': const WorkersListView()},
    {'title': '06. More & Management Menu', 'widget': const MoreView()},
    {'title': '07. Emergency Contacts', 'widget': const EmergencyContactsView()},
    {'title': '08. Geofence & Restricted Area', 'widget': const GeofenceView()},
    {'title': '09. Device Status (0 Hardware)', 'widget': const DeviceStatusView()},
    {'title': '10. Message Worker (Chat)', 'widget': const MessageWorkerView(workerName: 'Suresh')},
    {'title': '11. Plant Areas Overview', 'widget': const PlantAreasView()},
    {'title': '12. Safety Reports', 'widget': const ReportsView()},
    {'title': '13. Supervisor Profile', 'widget': const ProfileView()},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLarge = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: const [
            Icon(Icons.grid_view_rounded, color: AppColors.safetyAccent, size: 20),
            SizedBox(width: 8),
            Text(
              'SafeBand Multi-Screen Presentation Deck',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _gridColumns == 3 ? Icons.view_compact_rounded : Icons.grid_view_rounded,
              color: AppColors.safetyAccent,
            ),
            onPressed: () {
              setState(() {
                _gridColumns = _gridColumns == 3 ? 2 : 3;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.surface,
              child: Row(
                children: const [
                  Icon(Icons.shield_outlined, color: AppColors.safetyAccent, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SafeBand Commercial Industrial UI/UX — Dark Theme System (#111820 | #F5B91E Yellow)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondaryText),
                    ),
                  ),
                ],
              ),
            ),

            // Multi-screen Grid Deck View
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLarge ? _gridColumns : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isLarge ? 0.62 : 0.65,
                ),
                itemCount: _screens.length,
                itemBuilder: (context, index) {
                  final item = _screens[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.safetyAccent.withValues(alpha: 0.4), width: 1.5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 10, spreadRadius: 2),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mockup Frame Header Title Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          color: AppColors.cardBackground,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['title'] as String,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.safetyAccent),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.signal_cellular_alt_rounded, size: 12, color: AppColors.secondaryText),
                                  SizedBox(width: 4),
                                  Text('9:41', style: TextStyle(fontSize: 10, color: AppColors.secondaryText)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Embedded Screen Body Preview
                        Expanded(
                          child: Container(
                            color: AppColors.background,
                            child: AbsorbPointer(
                              absorbing: false,
                              child: item['widget'] as Widget,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
