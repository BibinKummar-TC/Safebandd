import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/metric_empty_card.dart';

class EnvironmentView extends StatelessWidget {
  const EnvironmentView({super.key});

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
          const Text(
            'Environmental Risk Matrix',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Atmospheric gas threshold monitoring & thermal stress indices',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),

          if (!hasData) ...[
            const EmptyStateCard(
              icon: Icons.air_rounded,
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
                MetricEmptyCard(label: 'Toxic Gas (CO/H2S)', icon: Icons.warning_amber_rounded, unit: 'PPM', value: '—'),
                MetricEmptyCard(label: 'Combustible Gas (CH4)', icon: Icons.local_fire_department_rounded, unit: '% LEL', value: '—'),
                MetricEmptyCard(label: 'Ambient Temperature', icon: Icons.thermostat_rounded, unit: '°C', value: '—'),
                MetricEmptyCard(label: 'Oxygen Saturation', icon: Icons.air_rounded, unit: '%', value: '—'),
                MetricEmptyCard(label: 'Relative Humidity', icon: Icons.water_drop_outlined, unit: '%', value: '—'),
                MetricEmptyCard(label: 'Barometric Pressure', icon: Icons.speed_rounded, unit: 'hPa', value: '—'),
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
                MetricEmptyCard(label: 'Toxic Gas (CO/H2S)', icon: Icons.warning_amber_rounded, unit: 'PPM', value: sensor.gasPpm?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Combustible Gas (CH4)', icon: Icons.local_fire_department_rounded, unit: '% LEL', value: '—'),
                MetricEmptyCard(label: 'Ambient Temperature', icon: Icons.thermostat_rounded, unit: '°C', value: sensor.temperatureC?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Oxygen Saturation', icon: Icons.air_rounded, unit: '%', value: sensor.oxygenPercent?.toStringAsFixed(1) ?? '—'),
                MetricEmptyCard(label: 'Relative Humidity', icon: Icons.water_drop_outlined, unit: '%', value: sensor.humidityPercent?.toStringAsFixed(0) ?? '—'),
                MetricEmptyCard(label: 'Barometric Pressure', icon: Icons.speed_rounded, unit: 'hPa', value: sensor.pressureHpa?.toStringAsFixed(0) ?? '—'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
