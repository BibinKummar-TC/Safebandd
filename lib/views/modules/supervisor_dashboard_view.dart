import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/safeband_data.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/sensor_simulation_badge.dart';
import '../common/call_dialog.dart';
import 'worker_details_view.dart';
import 'profile_view.dart';

class SupervisorDashboardView extends StatelessWidget {
  final Function(int)? onNavigateTab;
  final Function(String workerName)? onSelectWorker;

  const SupervisorDashboardView({
    super.key,
    this.onNavigateTab,
    this.onSelectWorker,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Supervisor Greeting Header Card
              _buildSupervisorHeader(context),
              const SizedBox(height: 14),

              // Simulation Mode Banner
              const SensorSimulationBadge(),
              const SizedBox(height: 2),

              // Critical Hazard Alert Highlight Card (Suresh - Area B)
              _buildCriticalAlertBanner(context),
              const SizedBox(height: 16),

              // Workforce Overview / Compact Summary Cards
              _buildWorkforceOverview(context),
              const SizedBox(height: 18),

              // Quick Actions Bar (Live Map, Workers, Alerts, Reports)
              _buildQuickActions(context),
              const SizedBox(height: 20),

              // Live Environmental Data Section (All values zero in simulation mode)
              _buildEnvironmentalSection(),
              const SizedBox(height: 22),

              // Live Workers Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LIVE WORKERS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onNavigateTab?.call(3), // Navigate to Workers tab
                    child: Row(
                      children: const [
                        Text(
                          'View All (12)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.safetyAccent,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.safetyAccent),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Live Workers Rows (Ravi, Karthik, Suresh, Arun, Manoj)
              _buildLiveWorkersList(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupervisorHeader(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final profile = auth.currentProfile;
    final userName = profile?.fullName.isNotEmpty == true ? profile!.fullName : 'Supervisor';
    final plantName = 'Chemical Industry Plant';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning,',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryText,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.safetyAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.factory_rounded, size: 14, color: AppColors.safetyAccent),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      plantName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.safetyAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileView()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.safetyAccent, width: 2),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.cardBackground,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.safetyAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalAlertBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.8), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CRITICAL ALERT • 10:24 AM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: AppColors.danger,
                      ),
                    ),
                    Text(
                      'Suresh — Area B – Chemical Unit',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DANGER',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Hazard condition flagged in Chemical Unit Sector 4. Immediate worker contact required.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.safetyAccent,
                      foregroundColor: AppColors.background,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.map_rounded, size: 15),
                    label: const Text(
                      'LOCATE ON MAP',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                    onPressed: () => onNavigateTab?.call(1), // Switch to Map tab
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.phone_rounded, size: 15),
                    label: const Text(
                      'CALL WORKER',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                    onPressed: () {
                      EmergencyCallDialog.show(
                        context,
                        contactName: 'Suresh',
                        contactSubtitle: 'Area B – Chemical Unit (SB1023)',
                        phoneNumber: '+91 98401 10003',
                        isWorker: true,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkforceOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WORKFORCE OVERVIEW',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'TOTAL WORKERS',
                count: '12',
                color: AppColors.primaryText,
                accentColor: AppColors.border,
                icon: Icons.people_outline_rounded,
                onTap: () => onNavigateTab?.call(3),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: 'SAFE',
                count: '10',
                color: AppColors.safe,
                accentColor: AppColors.safe,
                icon: Icons.check_circle_outline_rounded,
                onTap: () => onNavigateTab?.call(3),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: 'WARNING',
                count: '1',
                color: AppColors.warning,
                accentColor: AppColors.warning,
                icon: Icons.warning_amber_rounded,
                onTap: () => onNavigateTab?.call(3),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                title: 'DANGER',
                count: '1',
                color: AppColors.danger,
                accentColor: AppColors.danger,
                icon: Icons.error_outline_rounded,
                onTap: () => onNavigateTab?.call(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String count,
    required Color color,
    required Color accentColor,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: count == '1' && color == AppColors.danger
                ? AppColors.danger.withValues(alpha: 0.7)
                : AppColors.border,
            width: count == '1' && color == AppColors.danger ? 1.4 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Live Map', 'icon': Icons.map_outlined, 'tab': 1},
      {'label': 'Workers', 'icon': Icons.people_outline_rounded, 'tab': 3},
      {'label': 'Alerts', 'icon': Icons.notifications_none_rounded, 'tab': 2},
      {'label': 'More', 'icon': Icons.more_horiz_rounded, 'tab': 4},
    ];

    return Row(
      children: actions.map((act) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onNavigateTab?.call(act['tab'] as int),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(act['icon'] as IconData, size: 20, color: AppColors.safetyAccent),
                  const SizedBox(height: 4),
                  Text(
                    act['label'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnvironmentalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'LIVE ENVIRONMENTAL DATA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.secondaryText,
                ),
              ),
              SensorSimulationBadge(compact: true),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            SafeBandData.simulationDisclaimer,
            style: TextStyle(fontSize: 11, color: AppColors.mutedText),
          ),
          const SizedBox(height: 14),

          // 4 Environmental Sensor Tiles (CO, H2S, Temperature, Humidity)
          Row(
            children: [
              Expanded(
                child: _sensorMetricTile(
                  label: 'CO',
                  unit: '0 ppm',
                  sub: 'Carbon Monoxide',
                  icon: Icons.air_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _sensorMetricTile(
                  label: 'H₂S',
                  unit: '0 ppm',
                  sub: 'Hydrogen Sulfide',
                  icon: Icons.science_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _sensorMetricTile(
                  label: 'Temperature',
                  unit: '0 °C',
                  sub: 'Ambient Temp',
                  icon: Icons.thermostat_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _sensorMetricTile(
                  label: 'Humidity',
                  unit: '0 %',
                  sub: 'Relative RH',
                  icon: Icons.water_drop_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sensorMetricTile({
    required String label,
    required String unit,
    required String sub,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 18, color: AppColors.safetyAccent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.disabledText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveWorkersList(BuildContext context) {
    // 5 primary live workers required by prompt:
    // Ravi (Area A - Reactor Unit, SAFE)
    // Karthik (Area B - Storage, WARNING)
    // Suresh (Area B - Chemical Unit, DANGER)
    // Arun (Area C - Distillation, SAFE)
    // Manoj (Area D - Utility, SAFE)
    final primaryWorkers = SafeBandData.workers.take(5).toList();

    return Column(
      children: primaryWorkers.map((worker) {
        final isDanger = worker.status == WorkerSafetyStatus.danger;
        final isWarning = worker.status == WorkerSafetyStatus.warning;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDanger ? AppColors.surface : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDanger
                  ? AppColors.danger.withValues(alpha: 0.8)
                  : (isWarning ? AppColors.warning.withValues(alpha: 0.5) : AppColors.border),
              width: isDanger ? 1.4 : 1.0,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkerDetailsView(workerName: worker.name),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    // Profile avatar with Hard Hat initial
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: worker.statusColor.withValues(alpha: 0.15),
                        border: Border.all(color: worker.statusColor, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          worker.initials,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: worker.statusColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name & Area
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                worker.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${worker.id})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            worker.area,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: worker.statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: worker.statusColor),
                      ),
                      child: Text(
                        worker.statusText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                          color: worker.statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Arrow
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
