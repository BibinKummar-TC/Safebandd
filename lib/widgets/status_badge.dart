import 'package:flutter/material.dart';
import '../config/constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isDotOnly;

  const StatusBadge({
    super.key,
    required this.status,
    this.isDotOnly = false,
  });

  Color _getStatusColor(String statusText) {
    switch (statusText.toLowerCase()) {
      case 'active':
      case 'normal':
      case 'connected':
      case 'operational':
        return AppColors.success;
      case 'warning':
      case 'acknowledged':
      case 'pending':
        return AppColors.warning;
      case 'high risk':
      case 'elevated':
        return AppColors.highRisk;
      case 'critical':
      case 'emergency':
      case 'offline':
      case 'disconnected':
        return AppColors.critical;
      default:
        return AppColors.secondaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    if (isDotOnly) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
