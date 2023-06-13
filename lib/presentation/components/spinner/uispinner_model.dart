import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class UiSpinnerModel {
  final String title;
  final ValueChanged<String>? onSpinChangedCategory;
  final ScrollController categoriesScrollController;
  final ScrollController? cardsScrollController;
  final List<UiEventModel> events;
  final List<String> categories;

  UiSpinnerModel(
      {this.title = 'Events you don’t wanna miss',
      this.onSpinChangedCategory,
      this.cardsScrollController,
      ScrollController? scrollController,
      required this.events,
      required this.categories})
      : categoriesScrollController = scrollController ?? ScrollController();
}
