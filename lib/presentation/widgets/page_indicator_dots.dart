import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PageIndicatorDots extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const PageIndicatorDots({
    Key? key,
    required this.pageCount,
    required this.currentPage,
    this.activeColor = AppColors.onboardingDotActive,
    this.inactiveColor = AppColors.onboardingDotInactive,
    this.dotSize = 8.0,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          width: dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}