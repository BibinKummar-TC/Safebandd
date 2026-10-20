import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../shell/app_shell.dart';

class ProfileView extends StatelessWidget {
  final bool isFromLogin;

  const ProfileView({super.key, this.isFromLogin = false});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final profile = auth.currentProfile;

    final initial = (profile?.fullName.isNotEmpty == true)
        ? profile!.fullName[0].toUpperCase()
        : 'S';
    final fullName = profile?.fullName.isNotEmpty == true
        ? profile!.fullName
        : 'Supervisor Profile';
    final email = profile?.email.isNotEmpty == true
        ? profile!.email
        : 'safety@company.com';
    final employeeId = profile?.employeeId.isNotEmpty == true
        ? profile!.employeeId
        : 'EMP-10492';
    final role = profile?.displayRole ?? 'Supervisor';
    final department = profile?.department.isNotEmpty == true
        ? profile!.department
        : 'Chemical Processing Unit';
    final workLocation = profile?.workLocation.isNotEmpty == true
        ? profile!.workLocation
        : 'Chemical Industry Plant';
    final shift = profile?.displayShift ?? 'Morning Shift (06:00 - 14:00)';
    final phone = profile?.phone != null && profile!.phone!.isNotEmpty
        ? profile.phone!
        : '+91 98765 43210';
    final status = profile?.accountStatus.toUpperCase() ?? 'ACTIVE';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: !isFromLogin,
        leading: isFromLogin
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          isFromLogin ? 'Worker Profile & Verification' : 'User Profile',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
        actions: [
          if (isFromLogin)
            TextButton.icon(
              icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.safetyAccent),
              label: const Text('Dashboard', style: TextStyle(color: AppColors.safetyAccent, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AppShell()),
                  (route) => false,
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (isFromLogin) ...[
                // Welcome Post-Login Alert Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.safetyAccent.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.safetyAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: AppColors.safetyAccent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Authentication Successful',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                            ),
                            Text(
                              'Verified identity for $fullName. Review assignment below and enter the dashboard.',
                              style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Header Avatar Profile Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.cardBackground,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.safetyAccent, width: 2.5),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.surface,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.safetyAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      fullName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.safetyAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.safetyAccent),
                          ),
                          child: Text(
                            role.toUpperCase(),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.safetyAccent),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.safe.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.safe),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.safe),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Button: Continue to Main Dashboard
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.safetyAccent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  icon: const Icon(Icons.dashboard_rounded, size: 20),
                  label: const Text(
                    'CONTINUE TO MAIN DASHBOARD',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.8),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AppShell()),
                      (route) => false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Account & Plant Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('WORKER & ASSIGNMENT DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 0.8)),
                    const SizedBox(height: 12),
                    _profileDetailRow('Employee ID', employeeId, Icons.badge_outlined),
                    const Divider(height: 16, color: AppColors.border),
                    _profileDetailRow('Department', department, Icons.corporate_fare_rounded),
                    const Divider(height: 16, color: AppColors.border),
                    _profileDetailRow('Work Location', workLocation, Icons.location_on_outlined),
                    const Divider(height: 16, color: AppColors.border),
                    _profileDetailRow('Assigned Shift', shift, Icons.schedule_rounded),
                    const Divider(height: 16, color: AppColors.border),
                    _profileDetailRow('Contact Phone', phone, Icons.phone_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Security & Settings Options
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _menuOption(Icons.lock_outline_rounded, 'Change Password', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _menuOption(Icons.edit_outlined, 'Edit Profile Details', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _menuOption(Icons.notifications_none_rounded, 'Safety Notification Preferences', () {}),
                    const Divider(height: 1, color: AppColors.border),
                    _menuOption(Icons.security_rounded, 'Security & MFA Devices', () {}),
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
                  label: const Text('LOGOUT', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.danger)),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.safetyAccent),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
      ],
    );
  }

  Widget _menuOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: AppColors.safetyAccent, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primaryText)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText, size: 20),
      onTap: onTap,
    );
  }
}
