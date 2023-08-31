import 'package:bubble_lens/bubble_lens.dart';
import 'package:flutter/material.dart';

class Bubbles extends StatelessWidget {
  final List<Widget> widgets;
  final double width;
  final double height;

  const Bubbles({
    super.key,
    required this.widgets,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BubbleLens(
      width: width,
      height: height,
      widgets: widgets,
      paddingX: 0,
      paddingY: 0,
      itemSize: 120,
      // duration: const Duration(milliseconds: 100),
      // highRatio: 0.25,
      // lowRatio: 0.01,
    );
  }
}
