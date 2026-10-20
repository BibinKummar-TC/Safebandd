import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../services/profile_service.dart';
import 'auth/login_screen.dart';

class ProfileView extends StatefulWidget {
  final bool isFromLogin;

  const ProfileView({super.key, this.isFromLogin = false});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileService _profileService = ProfileService();
  bool _isRefreshing = false;

  Future<void> _refreshProfile(AuthProvider auth) async {
    setState(() => _isRefreshing = true);
    if (auth.currentProfile != null) {
      await auth.loadUserProfile(auth.currentProfile!.id, auth.currentProfile!.email);
    }
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile synced with Supabase!'),
          backgroundColor: AppColors.safe,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showEditProfileDialog(BuildContext context, AuthProvider auth, UserProfile profile) {
    final nameController = TextEditingController(text: profile.fullName);
    final phoneController = TextEditingController(text: profile.phone ?? '');
    final deptController = TextEditingController(text: profile.department);
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Row(
            children: [
              Icon(Icons.edit_note_rounded, color: AppColors.safetyAccent),
              SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.primaryText),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.safetyAccent),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.primaryText),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppColors.safetyAccent),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deptController,
                  style: const TextStyle(color: AppColors.primaryText),
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.business_outlined, color: AppColors.safetyAccent),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      setDialogState(() => isSaving = true);
                      final updated = profile.copyWith(
                        fullName: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        department: deptController.text.trim(),
                        updatedAt: DateTime.now(),
                      );
                      final ok = await _profileService.createOrUpdateProfile(updated);
                      if (ok && mounted) {
                        await auth.loadUserProfile(updated.id, updated.email);
                        if (context.mounted) {
                          Navigator.of(dialogCtx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated in Supabase successfully!'),
                              backgroundColor: AppColors.safe,
                            ),
                          );
                        }
                      } else {
                        setDialogState(() => isSaving = false);
                      }
                    },
              child: isSaving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final profile = auth.currentProfile;

    final initial = (profile?.fullName.isNotEmpty == true)
        ? profile!.fullName[0].toUpperCase()
        : 'U';
    final fullName = profile?.fullName.isNotEmpty == true
        ? profile!.fullName
        : 'SafeBand User';
    final email = profile?.email.isNotEmpty == true
        ? profile!.email
        : 'user@safeband.internal';
    final employeeId = profile?.employeeId.isNotEmpty == true
        ? profile!.employeeId
        : 'EMP-PENDING';
    final role = profile?.displayRole ?? 'Worker';
    final department = profile?.department.isNotEmpty == true
        ? profile!.department
        : 'Industrial Operations';
    final workLocation = profile?.workLocation.isNotEmpty == true
        ? profile!.workLocation
        : 'Plant Operations';
    final shift = profile?.displayShift ?? 'Morning Shift (06:00 - 14:00)';
    final phone = profile?.phone != null && profile!.phone!.isNotEmpty
        ? profile.phone!
        : 'Not provided';
    final status = profile?.accountStatus.toUpperCase() ?? 'ACTIVE';
    final zone = profile?.assignedZone ?? 'General Facility';
    final createdDate = profile?.createdAt != null
        ? '${profile!.createdAt!.day.toString().padLeft(2, '0')}/${profile.createdAt!.month.toString().padLeft(2, '0')}/${profile.createdAt!.year}'
        : 'Registered';
    final lastLoginDate = profile?.lastLogin != null
        ? '${profile!.lastLogin!.hour.toString().padLeft(2, '0')}:${profile.lastLogin!.minute.toString().padLeft(2, '0')} (${profile.lastLogin!.day}/${profile.lastLogin!.month}/${profile.lastLogin!.year})'
        : 'Active Session';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'SafeBand Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
        actions: [
          IconButton(
            tooltip: 'Sync Supabase Profile',
            icon: _isRefreshing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.safetyAccent))
                : const Icon(Icons.sync_rounded, color: AppColors.safetyAccent),
            onPressed: _isRefreshing ? null : () => _refreshProfile(auth),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded, color: AppColors.critical),
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
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
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
                      child: const Icon(Icons.verified_user_rounded, color: AppColors.safetyAccent, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Supabase Authenticated',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                          ),
                          Text(
                            'Signed in as $fullName ($employeeId)',
                            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Header Avatar Profile Card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.cardBackground,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.safetyAccent, width: 2.5),
                        ),
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor: AppColors.surface,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 30,
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

              // Worker & Assignment Details
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('WORKER & ASSIGNMENT DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 0.8)),
                    const SizedBox(height: 14),
                    _profileDetailRow('Employee ID', employeeId, Icons.badge_outlined),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('Department', department, Icons.corporate_fare_rounded),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('Work Location', workLocation, Icons.location_on_outlined),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('Assigned Shift', shift, Icons.schedule_rounded),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('Assigned Zone', zone, Icons.layers_outlined),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('Contact Phone', phone, Icons.phone_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Supabase Account & Session Metadata
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SUPABASE DATABASE METADATA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 0.8)),
                    const SizedBox(height: 14),
                    _profileDetailRow('Table Source', 'public.profiles', Icons.table_chart_outlined),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('Member Since', createdDate, Icons.calendar_today_outlined),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('Last Login', lastLoginDate, Icons.login_rounded),
                    const Divider(height: 18, color: AppColors.border),
                    _profileDetailRow('User UUID', profile?.id.isNotEmpty == true && profile!.id.length > 12 ? '${profile.id.substring(0, 10)}...' : profile?.id ?? 'N/A', Icons.fingerprint_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Edit Profile Action
              if (profile != null)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.elevatedSurface,
                      foregroundColor: AppColors.primaryText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 18, color: AppColors.safetyAccent),
                    label: const Text('EDIT PROFILE DETAILS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                    onPressed: () => _showEditProfileDialog(context, auth, profile),
                  ),
                ),
              const SizedBox(height: 12),

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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText),
          ),
        ),
      ],
    );
  }
}
