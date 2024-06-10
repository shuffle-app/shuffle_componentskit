import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class LinearInfluencerIndicator extends StatefulWidget {
  final int actualSum;
  final int sum;
  final double? width;

  const LinearInfluencerIndicator({
    super.key,
    required this.actualSum,
    required this.sum,
    this.width,
  });

  @override
  State<LinearInfluencerIndicator> createState() => _LinearInfluencerIndicatorState();
}

class _LinearInfluencerIndicatorState extends State<LinearInfluencerIndicator> {
  late double _progressPosition;
  late final double _progressValue;
  late final double _indicatorWidth;
  final double _rightIndicatorEdge = 4.w;

  @override
  void initState() {
    super.initState();
    _setPercentage();
    _indicatorWidth = widget.width ?? 256.w;
    _setPositionWithPercentage();
  }

  void _setPercentage() {
    _progressValue = ((widget.actualSum / widget.sum) * 100);
  }

  void _setPositionWithPercentage() {
    _progressPosition = _indicatorWidth * (_progressValue / 100);
  }

  double _getCurrentPosition(double currentPosition) {
    if (currentPosition > _indicatorWidth - _rightIndicatorEdge) {
      return _indicatorWidth - _rightIndicatorEdge;
    }

    return currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.uiKitTheme?.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadiusFoundation.all40,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          ColoredBox(
            color: colorScheme?.darkNeutral200 ?? Colors.white,
            child: SizedBox(
              height: 6.h,
              width: _indicatorWidth,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedContainer(
                  width: _getCurrentPosition(_progressPosition),
                  curve: Curves.ease,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusFoundation.all40,
                    gradient: GradientFoundation.touchIdLinearGradient,
                    color: Colors.white,
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
