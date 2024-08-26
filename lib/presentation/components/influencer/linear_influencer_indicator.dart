import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class LinearInfluencerIndicator extends StatelessWidget {
  final double actualSum;
  final double sum;
  final double? width;
  final double? height;
  final Gradient? customGradient;
  final Color? customColor;
  final List<BoxShadow>? shadows;

  LinearInfluencerIndicator({
    super.key,
    required this.actualSum,
    required this.sum,
    this.width,
    this.height,
    this.customGradient,
    this.customColor,
    this.shadows,
  });

  late final double _indicatorWidth = width ?? 0.8.sw;

  double get progressPosition => _indicatorWidth * (_progressValue / 120);
  double get _progressValue => ((actualSum / sum) * 120);

  double _getCurrentPosition(double currentPosition) {
    if (currentPosition > _indicatorWidth) {
      return _indicatorWidth;
    }

    return currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.uiKitTheme?.colorScheme;
    final Color? color = customColor ?? colorScheme?.surface3;

    return ClipRRect(
      borderRadius: BorderRadiusFoundation.all40,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          ColoredBox(
            color: color ?? Colors.white,
            child: SizedBox(
              height: height ?? 6.h,
              width: max(_indicatorWidth, height ?? 6.h),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedContainer(
                  width: progressPosition == 0 ? 0 : max(_getCurrentPosition(progressPosition), height ?? 6.h),
                  curve: Curves.ease,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusFoundation.all40,
                    gradient: customGradient ?? GradientFoundation.touchIdLinearGradient,
                    color: Colors.white,
                    boxShadow: shadows,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
