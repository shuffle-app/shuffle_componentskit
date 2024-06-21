import '../components.dart';

class UiModelCategoryCreate {
  final String categoryTitle;
  final int categoryId;
  final List<UiModelPropertyType> categoryTypes;

  UiModelCategoryCreate({
    required this.categoryTitle,
    required this.categoryId,
    required this.categoryTypes,
  });
}
