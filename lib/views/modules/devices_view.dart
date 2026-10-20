import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/status_badge.dart';

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardProvider>(context);
    final devices = dashProvider.devices;

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
                    'SafeBand Device Fleet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ESP32 telemetry gateway & Bluetooth LE wearable wristband hardware',
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('PAIR DEVICE'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (devices.isEmpty) ...[
            const EmptyStateCard(
              icon: Icons.developer_board_off_rounded,
              title: 'No SafeBand devices paired',
              description: 'Connect an ESP32 micro-controller or SafeBand wearable device via Serial Gateway / BLE.',
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final dev = devices[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.watch_rounded, color: AppColors.safetyAccent),
                    title: Text(dev['mac_address']?.toString() ?? 'Device ID', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Battery: ${dev['battery'] ?? 100}% • Firmware v2.4.1'),
                    trailing: StatusBadge(status: dev['status']?.toString() ?? 'OFFLINE'),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
