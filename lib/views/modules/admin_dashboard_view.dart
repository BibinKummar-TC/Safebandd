import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/status_badge.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Administration & Database Center',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Supabase Database telemetry, organization profiles, RLS policies & hardware gateway status',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),

          // Admin Overview Cards
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildAdminCard('Total User Profiles', '${dashProvider.allWorkers.length} Users', Icons.people_alt_outlined),
              _buildAdminCard('Supabase Database', 'ONLINE', Icons.storage_rounded),
              _buildAdminCard('RLS Row Security', 'ACTIVE', Icons.lock_outline_rounded),
              _buildAdminCard('Device Gateway fleet', '${dashProvider.devices.length} Gateway Devices', Icons.developer_board_rounded),
            ],
          ),
          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Supabase Service Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                    StatusBadge(status: 'OPERATIONAL'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connected to Supabase PostgreSQL at https://atwuyvesdfxlebjsotio.supabase.co.',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Profiles Table Schema: id, employee_id, full_name, email, phone, department, role, work_location, shift, account_status, assigned_zone, created_at, updated_at, last_login',
                  style: TextStyle(fontSize: 12, fontFamily: 'Monospace', color: AppColors.mutedText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(String title, String value, IconData icon) {
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
              Icon(icon, size: 20, color: AppColors.safetyAccent),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
        ],
      ),
    );
  }
}
