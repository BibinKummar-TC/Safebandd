import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../common/call_dialog.dart';
import 'worker_details_view.dart';
import 'message_worker_view.dart';

class AlertsView extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const AlertsView({super.key, this.onNavigateTab});

  @override
  State<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<AlertsView> {
  String _selectedFilter = 'All'; // All, Danger, Warning, Information, Safe

  final List<Map<String, dynamic>> _alerts = [
    {
      'type': 'DANGER ALERT',
      'worker': 'Suresh',
      'location': 'Area B – Chemical Unit',
      'desc': 'Dangerous condition detected',
      'time': '10:24 AM',
      'color': AppColors.danger,
      'category': 'Danger',
      'icon': Icons.error_outline_rounded,
      'isCritical': true,
      'phone': '+91 98401 10003',
    },
    {
      'type': 'WARNING',
      'worker': 'Karthik',
      'location': 'Storage Unit',
      'desc': 'Temperature warning',
      'time': '09:50 AM',
      'color': AppColors.warning,
      'category': 'Warning',
      'icon': Icons.warning_amber_rounded,
      'isCritical': false,
      'phone': '+91 98401 10002',
    },
    {
      'type': 'RESTRICTED AREA',
      'worker': 'Arun',
      'location': 'Tank Farm',
      'desc': 'Worker entered restricted zone',
      'time': '09:10 AM',
      'color': AppColors.info,
      'category': 'Information',
      'icon': Icons.gpp_maybe_outlined,
      'isCritical': false,
      'phone': '+91 98401 10004',
    },
    {
      'type': 'DEVICE OFFLINE',
      'worker': 'Manoj',
      'location': 'Utility Area',
      'desc': 'SafeBand device disconnected',
      'time': '08:40 AM',
      'color': AppColors.info,
      'category': 'Information',
      'icon': Icons.sensors_off_rounded,
      'isCritical': false,
      'phone': '+91 98401 10005',
    },
    {
      'type': 'ALL WORKERS SAFE',
      'worker': 'All Workers',
      'location': 'Chemical Industry Plant',
      'desc': 'No active critical condition',
      'time': '08:30 AM',
      'color': AppColors.safe,
      'category': 'Safe',
      'icon': Icons.verified_user_outlined,
      'isCritical': false,
      'phone': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_selectedFilter == 'All') return _alerts;
    return _alerts.where((a) => a['category'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Alerts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.danger),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.circle, size: 8, color: AppColors.danger),
                        SizedBox(width: 6),
                        Text(
                          '1 ACTIVE DANGER',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.danger),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Filter Chips Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('All', AppColors.safetyAccent),
                    _filterChip('Danger', AppColors.danger),
                    _filterChip('Warning', AppColors.warning),
                    _filterChip('Information', AppColors.info),
                    _filterChip('Safe', AppColors.safe),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Alerts Cards List
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = _filteredAlerts[index];
                    final color = alert['color'] as Color;
                    final isDanger = alert['type'] == 'DANGER ALERT';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDanger ? AppColors.danger : AppColors.border,
                          width: isDanger ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(alert['icon'] as IconData, size: 20, color: color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: color.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: color),
                                            ),
                                            child: Text(
                                              alert['type'] as String,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                color: color,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            alert['time'] as String,
                                            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        alert['worker'] as String,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                      Text(
                                        alert['location'] as String,
                                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              alert['desc'] as String,
                              style: const TextStyle(fontSize: 13, color: AppColors.primaryText),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: AppColors.border),

                          // Action Buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (alert['phone'] != null) ...[
                                  TextButton.icon(
                                    icon: const Icon(Icons.phone_rounded, size: 14, color: AppColors.safetyAccent),
                                    label: const Text('CALL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.safetyAccent)),
                                    onPressed: () {
                                      EmergencyCallDialog.show(
                                        context,
                                        contactName: alert['worker'] as String,
                                        contactSubtitle: alert['location'] as String,
                                        phoneNumber: alert['phone'] as String,
                                        isWorker: true,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                if (alert['worker'] != 'All Workers') ...[
                                  TextButton.icon(
                                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.secondaryText),
                                    label: const Text('MESSAGE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => MessageWorkerView(workerName: alert['worker'] as String),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDanger ? AppColors.danger : AppColors.cardBackground,
                                      foregroundColor: isDanger ? Colors.white : AppColors.primaryText,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => WorkerDetailsView(workerName: alert['worker'] as String),
                                        ),
                                      );
                                    },
                                    child: const Text('VIEW DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, Color color) {
    final isSelected = _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? color : AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
