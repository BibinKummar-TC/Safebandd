import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/safeband_data.dart';
import '../common/call_dialog.dart';
import 'worker_details_view.dart';
import 'message_worker_view.dart';

class LiveMapView extends StatefulWidget {
  final Function(String workerName)? onSelectWorker;
  final String? initialWorkerName;

  const LiveMapView({
    super.key,
    this.onSelectWorker,
    this.initialWorkerName,
  });

  @override
  State<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends State<LiveMapView>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String _selectedWorkerName = 'Suresh';
  bool _showBottomCard = true;
  String _activeFilter = 'All'; // All, Danger, Warning, Safe
  int _activeLayer = 0; // 0: Schematic, 1: Heatmap/Hazard, 2: Geofence Focus
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    if (widget.initialWorkerName != null) {
      _selectedWorkerName = widget.initialWorkerName!;
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _transformController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final matrix = _transformController.value.clone();
    matrix.scaleByDouble(factor, factor, 1.0, 1.0);
    _transformController.value = matrix;
  }

  void _resetView() {
    _transformController.value = Matrix4.identity();
    setState(() {
      _selectedWorkerName = 'Suresh';
      _showBottomCard = true;
    });
  }

  void _cycleLayers() {
    setState(() {
      _activeLayer = (_activeLayer + 1) % 3;
    });
    final layerNames = ['Schematic Blueprint', 'Hazard Heatmap', 'Geofence Perimeter'];
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Layer: ${layerNames[_activeLayer]}'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<SafeBandWorker> _getFilteredWorkers() {
    final query = _searchController.text.toLowerCase().trim();
    return SafeBandData.workers.take(5).where((w) {
      final matchesQuery = query.isEmpty ||
          w.name.toLowerCase().contains(query) ||
          w.area.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (_activeFilter == 'Danger') {
        return w.status == WorkerSafetyStatus.danger;
      } else if (_activeFilter == 'Warning') {
        return w.status == WorkerSafetyStatus.warning;
      } else if (_activeFilter == 'Safe') {
        return w.status == WorkerSafetyStatus.safe;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selectedWorker = SafeBandData.getWorkerByName(_selectedWorkerName);
    final filteredWorkers = _getFilteredWorkers();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Interactive Pan & Zoom Plant Map Canvas
            InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.7,
              maxScale: 3.5,
              boundaryMargin: const EdgeInsets.all(200),
              child: SizedBox(
                width: 900,
                height: 900,
                child: Stack(
                  children: [
                    // Industrial Schematic Drawing
                    CustomPaint(
                      size: const Size(900, 900),
                      painter: IndustrialPlantCanvasPainter(layerMode: _activeLayer),
                    ),

                    // Plant Area Labels
                    _buildAreaLabel(
                      title: 'Area A – Reactor Unit',
                      x: 230,
                      y: 170,
                      color: AppColors.safe,
                    ),
                    _buildAreaLabel(
                      title: 'Area B – Storage',
                      x: 160,
                      y: 350,
                      color: AppColors.warning,
                    ),
                    _buildAreaLabel(
                      title: 'Area B – Chemical Unit (HAZARD)',
                      x: 420,
                      y: 400,
                      color: AppColors.danger,
                      isHazard: true,
                    ),
                    _buildAreaLabel(
                      title: 'Area C – Distillation',
                      x: 680,
                      y: 220,
                      color: AppColors.safe,
                    ),
                    _buildAreaLabel(
                      title: 'Area D – Utility Area',
                      x: 250,
                      y: 620,
                      color: AppColors.safe,
                    ),
                    _buildAreaLabel(
                      title: 'Tank Farm – Zone 1 [RESTRICTED]',
                      x: 650,
                      y: 650,
                      color: AppColors.danger,
                      isHazard: true,
                    ),

                    // Worker Pins
                    ...filteredWorkers.map((worker) {
                      final isSelected = worker.name == _selectedWorkerName;
                      final isDanger = worker.status == WorkerSafetyStatus.danger;

                      // Map normalized coordinates (0.0 - 1.0) to 900x900 canvas
                      final posX = worker.mapX * 900;
                      final posY = worker.mapY * 900;

                      return Positioned(
                        left: posX - 40,
                        top: posY - 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedWorkerName = worker.name;
                              _showBottomCard = true;
                            });
                          },
                          child: _buildWorkerPinWidget(
                            worker: worker,
                            isSelected: isSelected,
                            isDanger: isDanger,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Top Header Overlay: Flow Banner & Search Bar
            Positioned(
              top: 12,
              left: 14,
              right: 14,
              child: Column(
                children: [
                  // DETECT -> LOCATE -> CONTACT Flow Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.radar_rounded, size: 14, color: AppColors.danger),
                        SizedBox(width: 6),
                        Text(
                          'DETECT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.danger, letterSpacing: 0.8),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.secondaryText),
                        SizedBox(width: 6),
                        Icon(Icons.location_searching_rounded, size: 14, color: AppColors.safetyAccent),
                        SizedBox(width: 6),
                        Text(
                          'LOCATE',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.safetyAccent, letterSpacing: 0.8),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.secondaryText),
                        SizedBox(width: 6),
                        Icon(Icons.phone_in_talk_rounded, size: 14, color: AppColors.safe),
                        SizedBox(width: 6),
                        Text(
                          'CONTACT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.safe, letterSpacing: 0.8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Search Worker Input Bar
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 8),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 13, color: AppColors.primaryText),
                      decoration: InputDecoration(
                        hintText: 'Search worker (e.g. Suresh, Area B)...',
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.mutedText),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.secondaryText),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.secondaryText),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.safetyAccent),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Danger', 'Warning', 'Safe'].map((filter) {
                        final isSelected = _activeFilter == filter;
                        Color chipColor = AppColors.safetyAccent;
                        if (filter == 'Danger') chipColor = AppColors.danger;
                        if (filter == 'Warning') chipColor = AppColors.warning;
                        if (filter == 'Safe') chipColor = AppColors.safe;

                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _activeFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? chipColor.withValues(alpha: 0.2) : AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? chipColor : AppColors.border,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? chipColor : AppColors.secondaryText,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Right Floating Map Controls Column
            Positioned(
              right: 14,
              top: 140,
              child: Column(
                children: [
                  _mapButton(
                    icon: Icons.add_rounded,
                    tooltip: 'Zoom In',
                    onTap: () => _zoom(1.25),
                  ),
                  const SizedBox(height: 8),
                  _mapButton(
                    icon: Icons.remove_rounded,
                    tooltip: 'Zoom Out',
                    onTap: () => _zoom(0.8),
                  ),
                  const SizedBox(height: 8),
                  _mapButton(
                    icon: Icons.my_location_rounded,
                    tooltip: 'Current Location',
                    color: AppColors.safetyAccent,
                    onTap: _resetView,
                  ),
                  const SizedBox(height: 8),
                  _mapButton(
                    icon: Icons.layers_outlined,
                    tooltip: 'Map Layers',
                    onTap: _cycleLayers,
                  ),
                ],
              ),
            ),

            // Bottom Selected Worker Information Card (Default Suresh)
            if (_showBottomCard)
              Positioned(
                bottom: 12,
                left: 14,
                right: 14,
                child: _buildBottomWorkerCard(context, selectedWorker),
              ),
          ],
        ),
      ),
    );
  }

  Widget _mapButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color color = AppColors.primaryText,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 6)],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }

  Widget _buildAreaLabel({
    required String title,
    required double x,
    required double y,
    required Color color,
    bool isHazard = false,
  }) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isHazard ? AppColors.danger : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHazard) ...[
              const Icon(Icons.warning_amber_rounded, size: 12, color: AppColors.danger),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: isHazard ? AppColors.danger : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerPinWidget({
    required SafeBandWorker worker,
    required bool isSelected,
    required bool isDanger,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDanger ? AppColors.danger : AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDanger ? Colors.white : worker.statusColor,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: worker.statusColor.withValues(alpha: 0.5),
                    blurRadius: isDanger ? 12 : 6,
                  ),
                ],
              ),
              child: Text(
                '${worker.name} • ${worker.statusText}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isDanger ? Colors.white : worker.statusColor,
                ),
              ),
            ),
            const SizedBox(height: 2),

            // Pin icon with danger pulsing halo
            Stack(
              alignment: Alignment.center,
              children: [
                if (isDanger)
                  Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.danger.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: worker.statusColor,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 6),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      worker.initials,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomWorkerCard(BuildContext context, SafeBandWorker worker) {
    final isDanger = worker.status == WorkerSafetyStatus.danger;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDanger ? AppColors.danger : AppColors.border,
          width: isDanger ? 1.6 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 18, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row: Avatar, Name, Area, Status Badge, Close button
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: worker.statusColor.withValues(alpha: 0.15),
                  border: Border.all(color: worker.statusColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    worker.initials,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: worker.statusColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          worker.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${worker.id})',
                          style: const TextStyle(fontSize: 12, color: AppColors.mutedText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      worker.area,
                      style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                  ],
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
                    letterSpacing: 0.5,
                    color: worker.statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.secondaryText),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(() => _showBottomCard = false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),

          // Telemetry and Zero Sensor Values Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 13, color: AppColors.secondaryText),
                  const SizedBox(width: 4),
                  Text(
                    'Last Update: ${worker.lastUpdate}',
                    style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'CO: 0 ppm  •  H₂S: 0 ppm',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Buttons: CALL WORKER | VIEW DETAILS | MESSAGE
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.safetyAccent,
                      foregroundColor: AppColors.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.phone_rounded, size: 16),
                    label: const Text(
                      'CALL WORKER',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
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
                flex: 4,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WorkerDetailsView(workerName: worker.name),
                        ),
                      );
                    },
                    child: const Text(
                      'VIEW DETAILS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.safetyAccent),
                  tooltip: 'Send Message',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MessageWorkerView(workerName: worker.name),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom Industrial Chemical Plant Schematic Painter
class IndustrialPlantCanvasPainter extends CustomPainter {
  final int layerMode;

  IndustrialPlantCanvasPainter({this.layerMode = 0});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Blueprint Grid Lines
    final gridPaint = Paint()
      ..color = const Color(0xFF1E2A38)
      ..strokeWidth = 1.0;

    const gridSize = 45.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Road Network & Boundary Walls
    final roadPaint = Paint()
      ..color = const Color(0xFF141E28)
      ..style = PaintingStyle.fill;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFF2B3A4C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Main ring road
    final roadRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(40, 40, size.width - 80, size.height - 80),
      const Radius.circular(30),
    );
    canvas.drawRRect(roadRect, roadBorderPaint);

    // Cross roads
    canvas.drawRect(Rect.fromLTWH(380, 50, 40, size.height - 100), roadPaint);
    canvas.drawRect(Rect.fromLTWH(50, 500, size.width - 100, 40), roadPaint);

    // 3. Area A: Reactor Unit (Top Left)
    _drawIndustrialZone(
      canvas,
      rect: const Rect.fromLTWH(80, 80, 260, 220),
      borderColor: const Color(0xFF20C878),
      title: 'AREA A: REACTOR FACILITY',
      drawTanks: true,
      tankCount: 3,
    );

    // 4. Area B: Storage Bay (Mid Left)
    _drawIndustrialZone(
      canvas,
      rect: const Rect.fromLTWH(80, 320, 260, 160),
      borderColor: const Color(0xFFF5A623),
      title: 'AREA B: RAW STORAGE',
      drawWarehouses: true,
    );

    // 5. Area B: Chemical Unit (Center - DANGER ZONE)
    _drawHazardZone(
      canvas,
      rect: const Rect.fromLTWH(370, 320, 270, 240),
      label: 'AREA B: CHEMICAL SYNTHESIS',
      isDanger: true,
    );

    // 6. Area C: Distillation Unit (Top Right)
    _drawIndustrialZone(
      canvas,
      rect: const Rect.fromLTWH(660, 80, 200, 280),
      borderColor: const Color(0xFF3B82F6),
      title: 'AREA C: DISTILLATION TOWERS',
      drawTowers: true,
    );

    // 7. Area D: Utility & Power Substation (Bottom Left)
    _drawIndustrialZone(
      canvas,
      rect: const Rect.fromLTWH(80, 560, 260, 260),
      borderColor: const Color(0xFF64748B),
      title: 'AREA D: POWER & UTILITY',
    );

    // 8. Tank Farm – Zone 1: Geofenced Restricted Perimeter (Bottom Right)
    _drawGeofencedTankFarm(
      canvas,
      rect: const Rect.fromLTWH(620, 560, 240, 260),
    );

    // 9. Pipeline Networks (Yellow & Cyan conduits connecting units)
    _drawPipeConduits(canvas);
  }

  void _drawIndustrialZone(
    Canvas canvas, {
    required Rect rect,
    required Color borderColor,
    required String title,
    bool drawTanks = false,
    bool drawWarehouses = false,
    bool drawTowers = false,
    int tankCount = 2,
  }) {
    final fillPaint = Paint()
      ..color = const Color(0xFF131D27)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)), fillPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)), borderPaint);

    // Draw internal architectural structural icons
    final structuralPaint = Paint()
      ..color = const Color(0xFF223244)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    if (drawTanks) {
      // Cylindrical pressure tanks
      for (int i = 0; i < tankCount; i++) {
        final center = Offset(rect.left + 50 + (i * 70), rect.top + 100);
        canvas.drawCircle(center, 24, structuralPaint);
        canvas.drawCircle(center, 12, structuralPaint);
      }
    }

    if (drawWarehouses) {
      // Rectangular storage bays
      canvas.drawRect(Rect.fromLTWH(rect.left + 20, rect.top + 40, 80, 90), structuralPaint);
      canvas.drawRect(Rect.fromLTWH(rect.left + 120, rect.top + 40, 100, 90), structuralPaint);
    }

    if (drawTowers) {
      // Fractionation columns
      canvas.drawCircle(Offset(rect.left + 60, rect.top + 80), 30, structuralPaint);
      canvas.drawCircle(Offset(rect.left + 140, rect.top + 80), 24, structuralPaint);
      canvas.drawCircle(Offset(rect.left + 100, rect.top + 180), 32, structuralPaint);
    }
  }

  void _drawHazardZone(
    Canvas canvas, {
    required Rect rect,
    required String label,
    required bool isDanger,
  }) {
    // Fill with hazard tint
    final fillPaint = Paint()
      ..color = const Color(0xFF281318)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), fillPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), borderPaint);

    // Diagonal hazard stripes in zone
    final stripePaint = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: 0.15)
      ..strokeWidth = 4.0;

    for (double d = 0; d < rect.width + rect.height; d += 30) {
      final start = Offset(rect.left + d, rect.top);
      final end = Offset(rect.left, rect.top + d);
      canvas.drawLine(start, end, stripePaint);
    }

    // Reaction Vessels inside
    final vesselPaint = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset(rect.center.dx - 40, rect.center.dy), 28, vesselPaint);
    canvas.drawCircle(Offset(rect.center.dx + 40, rect.center.dy), 28, vesselPaint);
  }

  void _drawGeofencedTankFarm(Canvas canvas, {required Rect rect}) {
    final fillPaint = Paint()
      ..color = const Color(0xFF161C24)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)), fillPaint);

    // Dashed red fence perimeter
    final fencePaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const dashWidth = 8.0;
    const dashSpace = 6.0;

    // Draw dashed borders
    _drawDashedLine(canvas, Offset(rect.left, rect.top), Offset(rect.right, rect.top), fencePaint, dashWidth, dashSpace);
    _drawDashedLine(canvas, Offset(rect.right, rect.top), Offset(rect.right, rect.bottom), fencePaint, dashWidth, dashSpace);
    _drawDashedLine(canvas, Offset(rect.right, rect.bottom), Offset(rect.left, rect.bottom), fencePaint, dashWidth, dashSpace);
    _drawDashedLine(canvas, Offset(rect.left, rect.bottom), Offset(rect.left, rect.top), fencePaint, dashWidth, dashSpace);

    // 4 Large Storage Tanks
    final tankPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.fill;
    final tankBorder = Paint()
      ..color = const Color(0xFFEF4444).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final tCenters = [
      Offset(rect.left + 60, rect.top + 70),
      Offset(rect.left + 170, rect.top + 70),
      Offset(rect.left + 60, rect.top + 180),
      Offset(rect.left + 170, rect.top + 180),
    ];

    for (final tc in tCenters) {
      canvas.drawCircle(tc, 32, tankPaint);
      canvas.drawCircle(tc, 32, tankBorder);
      canvas.drawCircle(tc, 10, tankBorder);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint, double dashWidth, double dashSpace) {
    final distance = (p2 - p1).distance;
    final unitVector = (p2 - p1) / distance;
    double currentDistance = 0.0;

    while (currentDistance < distance) {
      final start = p1 + unitVector * currentDistance;
      final endDistance = math.min(currentDistance + dashWidth, distance);
      final end = p1 + unitVector * endDistance;
      canvas.drawLine(start, end, paint);
      currentDistance += dashWidth + dashSpace;
    }
  }

  void _drawPipeConduits(Canvas canvas) {
    final pipePaint = Paint()
      ..color = const Color(0xFFF5B91E).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Main central pipeline line
    final path = Path()
      ..moveTo(210, 300)
      ..lineTo(210, 400)
      ..lineTo(370, 400);
    canvas.drawPath(path, pipePaint);

    final path2 = Path()
      ..moveTo(640, 440)
      ..lineTo(760, 440)
      ..lineTo(760, 360);
    canvas.drawPath(path2, pipePaint);
  }

  @override
  bool shouldRepaint(covariant IndustrialPlantCanvasPainter oldDelegate) {
    return oldDelegate.layerMode != layerMode;
  }
}
