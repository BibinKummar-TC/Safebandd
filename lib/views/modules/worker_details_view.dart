import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/safeband_data.dart';
import '../../widgets/sensor_simulation_badge.dart';
import '../common/call_dialog.dart';
import 'message_worker_view.dart';

class WorkerDetailsView extends StatefulWidget {
  final String workerName;

  const WorkerDetailsView({
    super.key,
    this.workerName = 'Suresh',
  });

  @override
  State<WorkerDetailsView> createState() => _WorkerDetailsViewState();
}

class _WorkerDetailsViewState extends State<WorkerDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final worker = SafeBandData.getWorkerByName(widget.workerName);
    final isDanger = worker.status == WorkerSafetyStatus.danger;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Worker Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryText),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.secondaryText, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing safety profile of ${worker.name}...'),
                  backgroundColor: AppColors.surface,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Worker Profile Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDanger ? AppColors.danger : AppColors.border,
                    width: isDanger ? 1.6 : 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with Hard Hat
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: worker.statusColor.withValues(alpha: 0.15),
                            border: Border.all(color: worker.statusColor, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              worker.initials,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: worker.statusColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Worker Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    worker.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
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
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                        color: worker.statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              _detailRow('Worker ID:', worker.id),
                              _detailRow('Department:', worker.department),
                              _detailRow('Area:', worker.area, isHighlight: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Action Buttons Row: CALL WORKER | SEND MESSAGE | LOCATE ON MAP
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.safetyAccent,
                          foregroundColor: AppColors.background,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.phone_rounded, size: 16),
                        label: const Text(
                          'CALL WORKER',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                        ),
                        onPressed: () {
                          EmergencyCallDialog.show(
                            context,
                            contactName: worker.name,
                            contactSubtitle: '${worker.area} (${worker.id})',
                            phoneNumber: worker.phone,
                            isWorker: true,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.safetyAccent),
                        label: const Text(
                          'SEND MESSAGE',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MessageWorkerView(workerName: worker.name),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.map_outlined, size: 16, color: AppColors.safe),
                      label: const Text(
                        'LOCATE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Simulation Mode Notice Banner
              const SensorSimulationBadge(),
              const SizedBox(height: 8),

              // Tab Bar (Live Data | Location | Activity)
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.safetyAccent,
                  indicatorWeight: 3,
                  labelColor: AppColors.safetyAccent,
                  unselectedLabelColor: AppColors.secondaryText,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Live Data'),
                    Tab(text: 'Location'),
                    Tab(text: 'Activity'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Tab Views
              SizedBox(
                height: 380,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLiveDataTab(worker),
                    _buildLocationTab(worker),
                    _buildActivityTab(worker),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? AppColors.safetyAccent : AppColors.primaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDataTab(SafeBandWorker worker) {
    return Column(
      children: [
        // 4 Sensor Cards: CO, H2S, Temperature, Humidity (All 0 in simulation mode)
        Row(
          children: [
            Expanded(
              child: _sensorCard(
                label: 'CO',
                val: '0 ppm',
                sub: 'Carbon Monoxide',
                icon: Icons.air_rounded,
                threshold: 'Normal: < 25 ppm',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _sensorCard(
                label: 'H₂S',
                val: '0 ppm',
                sub: 'Hydrogen Sulfide',
                icon: Icons.warning_amber_rounded,
                threshold: 'Normal: < 10 ppm',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _sensorCard(
                label: 'Temperature',
                val: '0 °C',
                sub: 'Body/Ambient',
                icon: Icons.thermostat_rounded,
                threshold: 'Normal: 20-35 °C',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _sensorCard(
                label: 'Humidity',
                val: '0 %',
                sub: 'Relative Humidity',
                icon: Icons.water_drop_rounded,
                threshold: 'Normal: 30-70 %',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Device Connection & Battery Status Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.watch_rounded, size: 18, color: AppColors.secondaryText),
                      SizedBox(width: 8),
                      Text(
                        'Hardware: Not Connected',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'SIMULATION',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.warning),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Battery: 0 %', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.disabledText)),
                  Text('Connection: Not Connected', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.disabledText)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sensorCard({
    required String label,
    required String val,
    required String sub,
    required IconData icon,
    required String threshold,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
              ),
              Icon(icon, size: 16, color: AppColors.secondaryText),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            val,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryText),
          ),
          const SizedBox(height: 2),
          Text(
            threshold,
            style: const TextStyle(fontSize: 10, color: AppColors.disabledText),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTab(SafeBandWorker worker) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ASSIGNED PLANT LOCATION',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Text(
            worker.area,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.safetyAccent),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          _infoPair('Department Unit', worker.department),
          const SizedBox(height: 8),
          _infoPair('Plant Coordinate', '12° 58\' 44.2" N, 80° 13\' 22.8" E'),
          const SizedBox(height: 8),
          _infoPair('Assigned Shift', worker.shift),
          const SizedBox(height: 8),
          _infoPair('Geofence Restriction', 'Zone B Proximity Alert active'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.safetyAccent,
                side: const BorderSide(color: AppColors.safetyAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.center_focus_strong_rounded, size: 16),
              label: const Text('FOCUS WORKER ON LIVE MAP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(SafeBandWorker worker) {
    final activities = [
      {
        'title': 'Dangerous Condition Flagged',
        'time': '10:24 AM',
        'sub': 'Automated hazard alert triggered in Chemical Unit',
        'color': AppColors.danger,
        'icon': Icons.warning_amber_rounded,
      },
      {
        'title': 'Simulation Mode Sync Check',
        'time': '09:40 AM',
        'sub': 'Zero telemetry poll completed without physical hardware',
        'color': AppColors.info,
        'icon': Icons.sync_rounded,
      },
      {
        'title': 'Shift Check-in Confirmed',
        'time': '08:00 AM',
        'sub': 'Worker badge verified at Sector B entry gate',
        'color': AppColors.safe,
        'icon': Icons.check_circle_outline_rounded,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(height: 14, color: AppColors.border),
        itemBuilder: (context, index) {
          final act = activities[index];
          final color = act['color'] as Color;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(act['icon'] as IconData, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          act['title'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                        ),
                        Text(
                          act['time'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      act['sub'] as String,
                      style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoPair(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
      ],
    );
  }
}
