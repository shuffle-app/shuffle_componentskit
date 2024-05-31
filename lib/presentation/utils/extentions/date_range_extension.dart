import 'package:flutter/material.dart';

extension DateRangeExtension on DateTimeRange {
  DateTimeRange copyWith({
    DateTime? start,
    DateTime? end,
  }) {
    return DateTimeRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}
