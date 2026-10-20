import 'package:flutter/material.dart';
import '../config/constants.dart';

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? actionWidget;
  final bool isCompact;

  const EmptyStateCard({
    super.key,
    this.icon = Icons.sensors_off_rounded,
    required this.title,
    required this.description,
    this.actionWidget,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 20.0 : 36.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isCompact ? 12 : 18),
            decoration: BoxDecoration(
              color: AppColors.elevatedSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              icon,
              size: isCompact ? 28 : 40,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: isCompact ? 12 : 20),
          Text(
            title,
            style: TextStyle(
              fontSize: isCompact ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: isCompact ? 13 : 14,
              color: AppColors.secondaryText,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionWidget != null) ...[
            const SizedBox(height: 20),
            actionWidget!,
          ]
        ],
      ),
    );
  }
}
