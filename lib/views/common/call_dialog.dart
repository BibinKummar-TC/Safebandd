import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/constants.dart';

class EmergencyCallDialog extends StatefulWidget {
  final String contactName;
  final String contactSubtitle;
  final String? phoneNumber;
  final bool isWorker;

  const EmergencyCallDialog({
    super.key,
    required this.contactName,
    required this.contactSubtitle,
    this.phoneNumber,
    this.isWorker = true,
  });

  static Future<void> show(
    BuildContext context, {
    required String contactName,
    required String contactSubtitle,
    String? phoneNumber,
    bool isWorker = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EmergencyCallDialog(
        contactName: contactName,
        contactSubtitle: contactSubtitle,
        phoneNumber: phoneNumber,
        isWorker: isWorker,
      ),
    );
  }

  @override
  State<EmergencyCallDialog> createState() => _EmergencyCallDialogState();
}

class _EmergencyCallDialogState extends State<EmergencyCallDialog> {
  bool _isMuted = false;
  bool _isSpeaker = true;
  bool _isConnected = false;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate call connecting after 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (mounted) setState(() => _seconds++);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Top Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _isConnected
                    ? AppColors.safe.withValues(alpha: 0.15)
                    : AppColors.safetyAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isConnected ? AppColors.safe : AppColors.safetyAccent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isConnected ? Icons.call_rounded : Icons.ring_volume_rounded,
                    size: 13,
                    color: _isConnected ? AppColors.safe : AppColors.safetyAccent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isConnected ? 'CALL CONNECTED • ${_formatDuration(_seconds)}' : 'CALLING SAFEBAND DEVICE...',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: _isConnected ? AppColors.safe : AppColors.safetyAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Contact Avatar with Pulsing Halo
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isWorker ? AppColors.safetyAccent.withValues(alpha: 0.3) : AppColors.info.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.cardBackground,
                  child: Text(
                    widget.contactName.isNotEmpty ? widget.contactName[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: widget.isWorker ? AppColors.safetyAccent : AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name & Subtitle
            Text(
              widget.contactName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.contactSubtitle,
              style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            if (widget.phoneNumber != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.phoneNumber!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.safetyAccent),
              ),
            ],
            const SizedBox(height: 28),

            // In-call Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _callActionButton(
                  icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  label: _isMuted ? 'Muted' : 'Mute',
                  isActive: _isMuted,
                  onTap: () => setState(() => _isMuted = !_isMuted),
                ),
                _callActionButton(
                  icon: _isSpeaker ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                  label: _isSpeaker ? 'Speaker On' : 'Speaker Off',
                  isActive: _isSpeaker,
                  onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                ),
                _callActionButton(
                  icon: Icons.dialpad_rounded,
                  label: 'Keypad',
                  isActive: false,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),

            // End Call Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                icon: const Icon(Icons.call_end_rounded, size: 22),
                label: const Text(
                  'END CALL',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _callActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.safetyAccent : AppColors.cardBackground,
              border: Border.all(color: isActive ? AppColors.safetyAccent : AppColors.border),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.background : AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
