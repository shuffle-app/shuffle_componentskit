import 'package:flutter/material.dart';

extension AligmentExtention on Alignment? {
  MainAxisAlignment get mainAxisAlignment {
    if (this == null) return MainAxisAlignment.start;
    final pos = this!.y;

    if (pos == 0) {
      return MainAxisAlignment.center;
    } else if (pos < 0) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.end;
    }
  }

  CrossAxisAlignment get crossAxisAlignment {
    if (this == null) return CrossAxisAlignment.center;
    final pos = this!.x;

    if (pos == 0) {
      return CrossAxisAlignment.center;
    } else if (pos < 0) {
      return CrossAxisAlignment.start;
    } else {
      return CrossAxisAlignment.end;
    }
  }
}
