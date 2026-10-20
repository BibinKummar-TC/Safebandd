import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/metric_empty_card.dart';

class LiveMonitoringView extends StatelessWidget {
  const LiveMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardProvider>(context);
    final sensor = dashProvider.latestSensorData;
    final hasData = sensor != null && sensor.isAvailable;

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
                    'Live Monitoring Feed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Real-time ESP32 gateway telemetry stream & wearable sensors',
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => dashProvider.refresh(),
                icon: const Icon(Icons.sync_rounded, size: 18),
                label: const Text('POLL GATEWAY'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (!hasData) ...[
            const EmptyStateCard(
              icon: Icons.radar_rounded,
              title: 'No sensor data available',
              description: 'Connect a SafeBand device to begin environmental monitoring.',
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                MetricEmptyCard(label: 'Gas Level (PPM)', icon: Icons.cloud_outlined, unit: 'PPM', value: '—'),
                MetricEmptyCard(label: 'Atmospheric Pressure', icon: Icons.speed_rounded, unit: 'hPa', value: '—'),
                MetricEmptyCard(label: 'Temperature', icon: Icons.thermostat_rounded, unit: '°C', value: '—'),
                MetricEmptyCard(label: 'Oxygen Level (O2)', icon: Icons.air_rounded, unit: '%', value: '—'),
                MetricEmptyCard(label: 'Relative Humidity', icon: Icons.water_drop_outlined, unit: '%', value: '—'),
                MetricEmptyCard(label: 'Heart Rate', icon: Icons.favorite_outline_rounded, unit: 'BPM', value: '—'),
              ],
            ),
          ] else ...[
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                MetricEmptyCard(label: 'Gas Level (PPM)', icon: Icons.cloud_outlined, unit: 'PPM', value: sensor.gasPpm?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Atmospheric Pressure', icon: Icons.speed_rounded, unit: 'hPa', value: sensor.pressureHpa?.toStringAsFixed(0) ?? '—'),
                MetricEmptyCard(label: 'Temperature', icon: Icons.thermostat_rounded, unit: '°C', value: sensor.temperatureC?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Oxygen Level (O2)', icon: Icons.air_rounded, unit: '%', value: sensor.oxygenPercent?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Relative Humidity', icon: Icons.water_drop_outlined, unit: '%', value: sensor.humidityPercent?.toStringAsFixed(0) ?? '—'),
                MetricEmptyCard(label: 'Heart Rate', icon: Icons.favorite_outline_rounded, unit: 'BPM', value: sensor.heartRateBpm?.toString() ?? '—'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
