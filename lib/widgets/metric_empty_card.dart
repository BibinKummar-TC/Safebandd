import 'package:flutter/material.dart';
import '../config/constants.dart';

class MetricEmptyCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String unit;
  final String? value;

  const MetricEmptyCard({
    super.key,
    required this.label,
    required this.icon,
    required this.unit,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty && value != '—';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.mutedText),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: hasValue ? AppColors.success : AppColors.mutedText.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value ?? '—',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: hasValue ? AppColors.primaryText : AppColors.mutedText,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasValue ? 'Live Sensor Feed' : 'No Data Available',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: hasValue ? AppColors.success : AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
