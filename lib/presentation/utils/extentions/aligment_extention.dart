import 'package:flutter/material.dart';

extension AligmentExtention on Alignment? {
  MainAxisAlignment get mainAxisAlignment {
    if (this == null) return MainAxisAlignment.start;
    final y = this!.y;

    if (y == 0) {
      return MainAxisAlignment.center;
    } else if (y < 0) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.end;
    }
  }

  CrossAxisAlignment get crossAxisAlignment {
    if (this == null) return CrossAxisAlignment.center;
    final x = this!.x;

    if (x == 0) {
      return CrossAxisAlignment.center;
    } else if (x < 0) {
      return CrossAxisAlignment.start;
    } else {
      return CrossAxisAlignment.end;
    }
  }
}
