import 'package:flutter/material.dart';

extension ColumnAligment on Alignment? {
  MainAxisAlignment get mainAxisAlignment {
    if (this == null) return MainAxisAlignment.start;
    final y = this!.y;

    return y == 0
        ? MainAxisAlignment.center
        : y < 0
            ? MainAxisAlignment.start
            : MainAxisAlignment.end;
  }

  CrossAxisAlignment get crossAxisAlignment {
    if (this == null) return CrossAxisAlignment.center;
    final x = this!.x;

    return x == 0
        ? CrossAxisAlignment.center
        : x < 0
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end;
  }
}
