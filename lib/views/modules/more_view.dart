import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import 'emergency_contacts_view.dart';
import 'geofence_view.dart';
import 'device_status_view.dart';
import 'plant_areas_view.dart';
import 'reports_view.dart';
import 'profile_view.dart';
import 'workers_list_view.dart';
import 'alerts_view.dart';
import '../auth/login_screen.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final profile = auth.currentProfile;
    final userName = profile?.fullName.isNotEmpty == true ? profile!.fullName : 'Site Supervisor';
    final userEmail = profile?.email ?? 'supervisor@safeband.io';
    final plant = profile?.workLocation.isNotEmpty == true ? profile!.workLocation : 'Chemical Industry Plant';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              const Text(
                'More',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryText),
              ),
              const SizedBox(height: 14),

              // Supervisor Profile Card
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileView()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.safetyAccent, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.cardBackground,
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                            style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.safetyAccent, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              userEmail,
                              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$plant • Site Supervisor',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.safetyAccent),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Menu Options Group (All required by prompt)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _menuTile(
                      context,
                      icon: Icons.people_outline_rounded,
                      title: 'Worker Management',
                      subtitle: '12 Plant workers assigned',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WorkersListView()));
                      },
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.notifications_none_rounded,
                      title: 'Alert Settings',
                      subtitle: 'Siren thresholds & audio alarms',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AlertsView()));
                      },
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.gpp_maybe_rounded,
                      title: 'Geofence Settings',
                      subtitle: 'Tank Farm – Zone 1 perimeter',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GeofenceView()));
                      },
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.watch_rounded,
                      title: 'Device Management',
                      subtitle: 'SafeBand Watch status & BLE scan',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DeviceStatusView()));
                      },
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.contact_phone_outlined,
                      title: 'Emergency Contacts',
                      subtitle: 'Plant Manager, Fire, Safety Officers',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyContactsView()));
                      },
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.factory_outlined,
                      title: 'Plant Areas',
                      subtitle: '6 Active industrial plant sectors',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlantAreasView()));
                      },
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.insert_chart_outlined,
                      title: 'Reports',
                      subtitle: 'Telemetry audit & workforce statistics',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportsView()));
                      },
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.menu_book_rounded,
                      title: 'Safety Guidelines',
                      subtitle: 'OSHA & chemical protocol manual',
                      onTap: () => _showSafetyGuidelines(context),
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      subtitle: 'Technical assistance hotline',
                      onTap: () => _showHelpSupport(context),
                    ),
                    _divider(),
                    _menuTile(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: 'About SafeBand',
                      subtitle: 'v2.4.0 Enterprise Wearable Platform',
                      onTap: () => _showAboutSafeBand(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  icon: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 18),
                  label: const Text(
                    'LOGOUT',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.danger),
                  ),
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.safetyAccent, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryText)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.mutedText)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText, size: 18),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(height: 1, color: AppColors.border);

  void _showSafetyGuidelines(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Industrial Safety Guidelines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
            SizedBox(height: 12),
            Text('1. Continuous Wearable Monitoring: Every worker in Chemical Units must wear calibrated SafeBand devices.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
            SizedBox(height: 8),
            Text('2. Instant Evacuation: When a DANGER alert is triggered, workers must evacuate to Muster Point 2 immediately.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
            SizedBox(height: 8),
            Text('3. Geofence Compliance: Entering Tank Farm Zone 1 requires level-A hazmat suits and supervisor authorization.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
          ],
        ),
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Help & Support', style: TextStyle(color: AppColors.primaryText)),
        content: const Text(
          'SafeBand 24/7 Safety Command Hotline:\n\nPhone: +91 1800 555 7233\nEmail: support@safeband.io\nSite Operator: Central Control Room B',
          style: TextStyle(color: AppColors.secondaryText, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(color: AppColors.safetyAccent)),
          ),
        ],
      ),
    );
  }

  void _showAboutSafeBand(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('About SafeBand', style: TextStyle(color: AppColors.primaryText)),
        content: const Text(
          'SafeBand Enterprise V2.4.0\n\nIndustrial Worker Safety & Environmental Awareness Platform.\nDesigned for chemical refineries, manufacturing, factories, and hazardous environments.',
          style: TextStyle(color: AppColors.secondaryText, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.safetyAccent)),
          ),
        ],
      ),
    );
  }
}
