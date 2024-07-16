import '../components.dart';

class UiModelCategoryParent {
  final String categoryTitle;
  final int categoryId;
  final String? iconPath;
  final List<UiModelPropertiesCategory> categoryTypes;

  UiModelCategoryParent({
    required this.categoryTitle,
    required this.categoryId,
    required this.categoryTypes,
    required this.iconPath,
  });
}
