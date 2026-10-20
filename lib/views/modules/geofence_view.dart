import 'package:flutter/material.dart';
import '../../config/constants.dart';

class GeofenceView extends StatefulWidget {
  const GeofenceView({super.key});

  @override
  State<GeofenceView> createState() => _GeofenceViewState();
}

class _GeofenceViewState extends State<GeofenceView> {
  bool _alertOnEntry = true;
  bool _alertOnExit = false;
  double _geofenceRadius = 200;

  @override
  Widget build(BuildContext context) {
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
          'Geofence Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restricted Zone Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.danger, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.gpp_maybe_rounded, color: AppColors.danger, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Tank Farm – Zone 1',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryText),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.danger),
                          ),
                          child: const Text(
                            'RESTRICTED',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.danger, letterSpacing: 0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Classification: High Chemical Hazard Perimeter (Explosive & Toxic Gas Storage)',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.danger),
                        SizedBox(width: 4),
                        Text(
                          'Entry strictly restricted to certified hazmat staff.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.danger),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Alert on Entry Switch (Exact prompt requirement)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Alert when worker enters',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Triggers immediate critical alert notification to supervisor dashboard.',
                                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _alertOnEntry,
                          activeThumbColor: AppColors.safetyAccent,
                          activeTrackColor: AppColors.safetyAccent.withValues(alpha: 0.3),
                          inactiveThumbColor: AppColors.secondaryText,
                          inactiveTrackColor: AppColors.border,
                          onChanged: (val) => setState(() => _alertOnEntry = val),
                        ),
                      ],
                    ),
                    const Divider(height: 18, color: AppColors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Alert when worker leaves safety buffer',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryText),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Notify when unauthorized personnel approach boundary.',
                                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _alertOnExit,
                          activeThumbColor: AppColors.safetyAccent,
                          activeTrackColor: AppColors.safetyAccent.withValues(alpha: 0.3),
                          inactiveThumbColor: AppColors.secondaryText,
                          inactiveTrackColor: AppColors.border,
                          onChanged: (val) => setState(() => _alertOnExit = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Plant Map Canvas Representation with Geofence Ring
              const Text(
                'GEOFENCE MAP RADAR',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 1.0),
              ),
              const SizedBox(height: 8),

              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D141C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Grid Lines
                    CustomPaint(
                      size: const Size(double.infinity, 200),
                      painter: _GeofenceRadarPainter(radius: _geofenceRadius),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.danger.withValues(alpha: 0.2),
                            border: Border.all(color: AppColors.danger, width: 2),
                          ),
                          child: const Icon(Icons.warning_amber_rounded, size: 28, color: AppColors.danger),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'RESTRICTED PERIMETER',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.danger, letterSpacing: 0.8),
                        ),
                        Text(
                          'Radius: ${_geofenceRadius.toInt()} meters',
                          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Perimeter Radius Slider
              Container(
                padding: const EdgeInsets.all(14),
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
                        const Text('Buffer Radius', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                        Text('${_geofenceRadius.toInt()} meters', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.safetyAccent)),
                      ],
                    ),
                    Slider(
                      value: _geofenceRadius,
                      min: 50,
                      max: 500,
                      divisions: 9,
                      activeColor: AppColors.safetyAccent,
                      inactiveColor: AppColors.border,
                      onChanged: (val) => setState(() => _geofenceRadius = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.safetyAccent,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Geofence policies updated successfully.'),
                        backgroundColor: AppColors.safe,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('SAVE GEOFENCE SETTINGS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeofenceRadarPainter extends CustomPainter {
  final double radius;

  _GeofenceRadarPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF1E2D3D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Concentric circles
    canvas.drawCircle(center, 40, paint);
    canvas.drawCircle(center, 70, paint);

    // Hazard zone boundary
    final hazardPaint = Paint()
      ..color = AppColors.danger.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, 70, hazardPaint);
  }

  @override
  bool shouldRepaint(covariant _GeofenceRadarPainter oldDelegate) => oldDelegate.radius != radius;
}
