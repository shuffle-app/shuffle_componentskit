import 'package:flutter/material.dart';

class UiUpcomingEventsSpinnerModel {
  final ValueChanged<String>? onSpinChangedCategory;
  final ScrollController categoriesScrollController;
  final ScrollController? cardsScrollController;

  UiUpcomingEventsSpinnerModel({
    required this.categoriesScrollController,
    this.onSpinChangedCategory,
    this.cardsScrollController,
  });
}
