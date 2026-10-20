import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System & Safety Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure platform parameters, Supabase connection & supervisor security options',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),

          // Supervisor Authorization Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.safetyAccent, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.verified_user_rounded, color: AppColors.safetyAccent),
                    SizedBox(width: 10),
                    Text(
                      'Plant Supervisor Authorization',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'This SafeBand application instance is exclusively authorized for Plant Supervisors with full floor monitoring access.',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0x1FF5B91E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0x4DF5B91E)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_rounded, color: AppColors.safetyAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Active Role: ${authProvider.activeRole}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.safetyAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Supabase Project Connection Status
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Database Connection Info',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                ),
                const SizedBox(height: 12),
                _buildConfigItem('Supabase Host URL', SupabaseConfig.url),
                _buildConfigItem('REST API Endpoint', SupabaseConfig.restUrl),
                _buildConfigItem('Profiles Table', 'public.profiles'),
                _buildConfigItem('RLS Status', 'Enabled (Active enforcement)'),
                _buildConfigItem('Real-time Telemetry Gateway', 'ESP32 REST / Supabase WebSockets'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sign Out CTA
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.critical),
                foregroundColor: AppColors.critical,
              ),
              onPressed: () async {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('SIGN OUT OF SAFEBAND'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.secondaryText)),
          Text(value, style: const TextStyle(fontSize: 13, fontFamily: 'Monospace', color: AppColors.primaryText)),
        ],
      ),
    );
  }
}
