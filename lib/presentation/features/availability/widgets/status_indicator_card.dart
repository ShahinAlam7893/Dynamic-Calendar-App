// lib/presentation/features/availability/widgets/status_indicator_card.dart
import 'package:flutter/material.dart';
import 'package:circleslate/core/constants/app_colors.dart';

class StatusIndicatorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusIndicatorCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent, // Blue border when selected
            width: isSelected ? 2.0 : 0.0,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: textColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}