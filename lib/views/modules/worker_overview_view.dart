import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/metric_empty_card.dart';
import '../../widgets/status_badge.dart';

class WorkerOverviewView extends StatelessWidget {
  const WorkerOverviewView({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dashProvider = Provider.of<DashboardProvider>(context);
    final profile = authProvider.currentProfile;

    final fullName = profile?.fullName ?? 'Worker';
    final employeeId = profile?.employeeId ?? '—';
    final role = profile?.role ?? 'Worker';
    final department = profile?.department ?? 'General Operations';
    final shift = profile?.shift ?? 'Day Shift (06:00 - 14:00)';
    final assignedZone = profile?.assignedZone ?? 'Zone A - Main Plant';

    final latestSensor = dashProvider.latestSensorData;
    final hasSensorData = latestSensor != null && latestSensor.isAvailable;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Worker Greeting & Header Info Card (Prompt Section 13)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, $fullName',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.elevatedSurface,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  'EMPLOYEE ID: $employeeId',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.safetyAccent,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const StatusBadge(status: 'ACTIVE'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Real-time Clock Widget
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('HH:mm:ss').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Monospace',
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 28, color: AppColors.border),

                // Role, Department, Shift, Zone row
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    _buildHeaderMetaItem(Icons.work_outline, 'Role', role),
                    _buildHeaderMetaItem(Icons.business_rounded, 'Department', department),
                    _buildHeaderMetaItem(Icons.schedule_rounded, 'Shift', shift),
                    _buildHeaderMetaItem(Icons.location_on_outlined, 'Assigned Zone', assignedZone),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SafeBand Hardware Connection Status Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.elevatedSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasSensorData ? AppColors.success.withValues(alpha: 0.15) : AppColors.mutedText.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasSensorData ? Icons.watch_outlined : Icons.phonelink_off_rounded,
                    color: hasSensorData ? AppColors.success : AppColors.secondaryText,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasSensorData ? 'SafeBand Device Connected' : 'SafeBand Device Disconnected / Not Paired',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasSensorData
                            ? 'Streaming real-time environmental data to Supabase gateway.'
                            : 'Waiting for Bluetooth LE / ESP32 Serial Gateway telemetry.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: hasSensorData ? 'CONNECTED' : 'DISCONNECTED'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Environmental Monitoring Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Environmental Monitoring',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Real-time atmospheric gas, thermal and physiological readings',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.secondaryText),
                tooltip: 'Check Sensor Feed',
                onPressed: () => dashProvider.refresh(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Metric Cards OR Professional Empty State Card (REAL DATA ONLY)
          if (!hasSensorData) ...[
            const EmptyStateCard(
              icon: Icons.sensors_off_rounded,
              title: 'No sensor data available',
              description: 'Connect a SafeBand device to begin environmental monitoring.',
            ),
            const SizedBox(height: 20),

            // Empty Sensor Metric Grid (Gas —, Pressure —, Temp —, Oxygen —, Humidity —, Heart Rate —)
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                MetricEmptyCard(label: 'Gas Concentration', icon: Icons.cloud_outlined, unit: 'PPM', value: '—'),
                MetricEmptyCard(label: 'Atmospheric Pressure', icon: Icons.speed_rounded, unit: 'hPa', value: '—'),
                MetricEmptyCard(label: 'Ambient Temperature', icon: Icons.thermostat_rounded, unit: '°C', value: '—'),
                MetricEmptyCard(label: 'Oxygen Level (O2)', icon: Icons.air_rounded, unit: '%', value: '—'),
                MetricEmptyCard(label: 'Relative Humidity', icon: Icons.water_drop_outlined, unit: '%', value: '—'),
                MetricEmptyCard(label: 'Heart Rate', icon: Icons.favorite_outline_rounded, unit: 'BPM', value: '—'),
              ],
            ),
          ] else ...[
            // Real Sensor Data Cards when connected
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                MetricEmptyCard(label: 'Gas Concentration', icon: Icons.cloud_outlined, unit: 'PPM', value: latestSensor.gasPpm?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Atmospheric Pressure', icon: Icons.speed_rounded, unit: 'hPa', value: latestSensor.pressureHpa?.toStringAsFixed(0) ?? '—'),
                MetricEmptyCard(label: 'Ambient Temperature', icon: Icons.thermostat_rounded, unit: '°C', value: latestSensor.temperatureC?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Oxygen Level (O2)', icon: Icons.air_rounded, unit: '%', value: latestSensor.oxygenPercent?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Relative Humidity', icon: Icons.water_drop_outlined, unit: '%', value: latestSensor.humidityPercent?.toStringAsFixed(0) ?? '—'),
                MetricEmptyCard(label: 'Heart Rate', icon: Icons.favorite_outline_rounded, unit: 'BPM', value: latestSensor.heartRateBpm?.toString() ?? '—'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderMetaItem(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.secondaryText),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.mutedText),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText),
            ),
          ],
        ),
      ],
    );
  }
}
