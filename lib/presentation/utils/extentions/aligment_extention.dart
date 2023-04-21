import 'package:flutter/material.dart';

extension ColumnAligment on Alignment? {
  MainAxisAlignment get mainAxisAlignment {
    if (this == null) return MainAxisAlignment.start;
    if (this!.x == 0) {
      return MainAxisAlignment.center;
    } else {
      return this!.x < 0 ? MainAxisAlignment.start : MainAxisAlignment.end;
    }
  }

  CrossAxisAlignment get crossAxisAlignment {
    if (this == null) return CrossAxisAlignment.center;
    if (this!.y == 0) {
      return CrossAxisAlignment.center;
    } else {
      return this!.y < 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    }
  }
}
