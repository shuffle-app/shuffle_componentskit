import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../components.dart';

class CategoriesManageComponent extends StatelessWidget {
  const CategoriesManageComponent({
    super.key,
    required this.onAddCategory,
    required this.onCategorySelect,
    this.onEditSelectedCategory,
    this.onDeleteSelectedCategory,
    this.isEntertainmentSelected = false,
    required this.propertySearchOptions,
    this.onPropertyFieldSubmitted,
    this.onPropertyEdit,
    this.onPropertyDeleteTap,
    this.onUniquePropertyFieldSubmitted,
    required this.uniquePropertySearchOptions,
    this.onRelatedPropertyFieldSubmitted,
    required this.relatedPropertySearchOptions,
    this.onSelectedRelatedPropertyTapped,
    required this.listCategories,
    this.selectedCategory,
    this.selectedProperty,
    this.onLoadMoreCategories,
    required this.onChangeType,
    this.relatedProperties,
    this.categoryProperties,
    required this.onPropertySelect,
  });

  int? get selectedCategoryId => selectedCategory?.id;

  final List<UiKitTag> listCategories;
  final UiKitTag? selectedCategory;
  final UiKitTag? selectedProperty;
  final VoidCallback onAddCategory;
  final VoidCallback onChangeType;
  final VoidCallback? onLoadMoreCategories;
  final ValueChanged<int> onCategorySelect;
  final ValueChanged<int> onPropertySelect;
  final VoidCallback? onEditSelectedCategory;
  final ValueChanged<UiKitTag>? onPropertyEdit;
  final VoidCallback? onDeleteSelectedCategory;
  final ValueChanged<UiKitTag>? onPropertyDeleteTap;
  final ValueChanged<String>? onPropertyFieldSubmitted;
  final ValueChanged<String>? onUniquePropertyFieldSubmitted;
  final ValueChanged<(String, UiKitTag?)>? onRelatedPropertyFieldSubmitted;
  final Future<List<String>> Function(String) propertySearchOptions;
  final Future<List<String>> Function(String) uniquePropertySearchOptions;
  final Future<List<String>> Function(String) relatedPropertySearchOptions;
  final ValueChanged<(UiKitTag, UiKitTag)>? onSelectedRelatedPropertyTapped;
  final bool isEntertainmentSelected;
  final List<UiModelRelatedProperty>? relatedProperties;
  final List<UiKitTag>? categoryProperties;

  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
    debugPrint('CategoriesCreateComponent build here with selectedProperty: ${selectedProperty?.title}');

    return Scaffold(
      body: UiKitCardWrapper(
        borderRadius: BorderRadiusFoundation.all16,
        padding: EdgeInsets.symmetric(
            horizontal: EdgeInsetsFoundation.horizontal32, vertical: EdgeInsetsFoundation.vertical20),
        color: uiKitTheme?.colorScheme.surface,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: PropertiesBorderedBox(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.current.Categories,
                          overflow: TextOverflow.ellipsis,
                          style: uiKitTheme?.boldTextTheme.title1,
                        ),
                      ),
                      SpacingFoundation.horizontalSpace16,
                      InkWell(
                          onTap: onChangeType,
                          child: Text(
                            isEntertainmentSelected ? S.current.Entertainment : S.current.Business,
                            style: uiKitTheme?.regularTextTheme.labelSmall,
                          )),
                      SpacingFoundation.horizontalSpace16,
                      context.boxIconButton(
                        data: BaseUiKitButtonData(
                          onPressed: onAddCategory,
                          backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
                          iconInfo: BaseUiKitButtonIconData(
                              iconData: ShuffleUiKitIcons.plus,
                              size: kIsWeb ? 24 : 24.sp,
                              color: ColorsFoundation.primary200),
                        ),
                      )
                    ],
                  ),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification.metrics.maxScrollExtent * 0.95 < notification.metrics.pixels) {
                        onLoadMoreCategories?.call();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: listCategories.length,
                      itemBuilder: (context, index) {
                        // return UiKitExpansionTileWithIconButton(
                        //   title: e.categoryTitle,
                        //   onTap: onCategoryTypeAddTap,
                        //   children: e.categoryTypes.map(
                        //     (element) {
                        //       return PropertiesTypeAnimatedButton(
                        //         title: element.title,
                        //         onTap: () {
                        //           onCategoryPropertyTypeButtonTap.call(element.id);
                        //         },
                        //       );
                        //     },
                        //   ).toList(),
                        // );
                        final category = listCategories.elementAt(index);
                        return PropertiesTypeAnimatedButton(
                          title: category.title,
                          onTap: () {
                            onCategorySelect.call(category.id!);
                          },
                          isSelected: selectedCategoryId == category.id,
                        );
                      },
                    ),
                  )),
            ),
            SpacingFoundation.horizontalSpace16,
            Flexible(
              child: PropertiesBorderedBox(
                title: selectedCategory != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageWidget(
                            link: selectedCategory?.icon ?? '',
                            width: kIsWeb ? 24 : 24.sp,
                            color: uiKitTheme?.themeMode == ThemeMode.light
                                ? ColorsFoundation.surface
                                : ColorsFoundation.lightSurface,
                          ),
                          SpacingFoundation.horizontalSpace4,
                          Expanded(
                            child: Text(
                              selectedCategory?.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: uiKitTheme?.boldTextTheme.title2,
                            ),
                          ),
                          SpacingFoundation.horizontalSpace16,
                          context.boxIconButton(
                            data: BaseUiKitButtonData(
                              onPressed: onEditSelectedCategory,
                              backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
                              iconInfo: BaseUiKitButtonIconData(
                                  iconData: ShuffleUiKitIcons.pencil,
                                  size: kIsWeb ? 16 : 16.sp,
                                  color: ColorsFoundation.primary200),
                            ),
                          ),
                          SpacingFoundation.horizontalSpace4,
                          context.boxIconButton(
                            data: BaseUiKitButtonData(
                              onPressed: onDeleteSelectedCategory,
                              backgroundColor: ColorsFoundation.danger.withOpacity(0.3),
                              iconInfo: BaseUiKitButtonIconData(
                                  iconData: ShuffleUiKitIcons.trash,
                                  size: kIsWeb ? 16 : 16.sp,
                                  color: ColorsFoundation.danger),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 24,
                      ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                      S.current.BaseProperties,
                      style: uiKitTheme?.boldTextTheme.subHeadline,
                    ),
                    SpacingFoundation.verticalSpace12,
                    PropertiesSearchInput(
                      options: propertySearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: onPropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace12,
                    UiKitPropertiesCloud(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (selectedProperty != null && !selectedProperty!.unique)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  context.boxIconButton(
                                    data: BaseUiKitButtonData(
                                      onPressed: () => onPropertyEdit?.call(selectedProperty!),
                                      backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
                                      iconInfo: BaseUiKitButtonIconData(
                                          iconData: ShuffleUiKitIcons.pencil,
                                          size: kIsWeb ? 16 : 16.sp,
                                          color: ColorsFoundation.primary200),
                                    ),
                                  ),
                                  SpacingFoundation.horizontalSpace4,
                                  context.boxIconButton(
                                    data: BaseUiKitButtonData(
                                      onPressed: () => onPropertyDeleteTap?.call(selectedProperty!),
                                      backgroundColor: ColorsFoundation.danger.withOpacity(0.3),
                                      iconInfo: BaseUiKitButtonIconData(
                                          iconData: ShuffleUiKitIcons.trash,
                                          size: kIsWeb ? 16 : 16.sp,
                                          color: ColorsFoundation.danger),
                                    ),
                                  ),
                                ],
                              ),
                            Wrap(
                                spacing: SpacingFoundation.horizontalSpacing12,
                                runSpacing: SpacingFoundation.verticalSpacing12,
                                children: (categoryProperties?.where((e) => !e.unique) ?? []).map(
                                  (e) {
                                    return UiKitCloudChip(
                                      iconPath: e.icon,
                                      title: e.title,
                                      selected: e == selectedProperty,
                                      onTap: () {
                                        onPropertySelect.call(e.id!);
                                      },
                                    );
                                  },
                                ).toList())
                          ]),
                    ),
                    SpacingFoundation.verticalSpace24,
                    Text(
                      S.current.UniqueProperties,
                      style: uiKitTheme?.boldTextTheme.subHeadline,
                    ),
                    SpacingFoundation.verticalSpace12,
                    PropertiesSearchInput(
                      options: uniquePropertySearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: onUniquePropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace12,
                    UiKitPropertiesCloud(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (selectedProperty != null && selectedProperty!.unique)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                context.boxIconButton(
                                  data: BaseUiKitButtonData(
                                    onPressed: () => onPropertyEdit?.call(selectedProperty!),
                                    backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
                                    iconInfo: BaseUiKitButtonIconData(
                                        iconData: ShuffleUiKitIcons.pencil,
                                        size: kIsWeb ? 16 : 16.sp,
                                        color: ColorsFoundation.primary200),
                                  ),
                                ),
                                SpacingFoundation.horizontalSpace4,
                                context.boxIconButton(
                                  data: BaseUiKitButtonData(
                                    onPressed: () => onPropertyDeleteTap?.call(selectedProperty!),
                                    backgroundColor: ColorsFoundation.danger.withOpacity(0.3),
                                    iconInfo: BaseUiKitButtonIconData(
                                        iconData: ShuffleUiKitIcons.trash,
                                        size: kIsWeb ? 16 : 16.sp,
                                        color: ColorsFoundation.danger),
                                  ),
                                ),
                              ],
                            ),
                          Wrap(
                              spacing: SpacingFoundation.horizontalSpacing12,
                              runSpacing: SpacingFoundation.verticalSpacing12,
                              children: (categoryProperties?.where((e) => e.unique) ?? []).map(
                                (e) {
                                  return UiKitCloudChip(
                                    title: e.title,
                                    onTap: () {
                                      onPropertySelect.call(e.id!);
                                    },
                                    iconPath: e.icon,
                                    selected: e == selectedProperty,
                                  );
                                },
                              ).toList()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace16,
            Flexible(
              child: PropertiesBorderedBox(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.current.RelatedPersonalProperties,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title2,
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertiesSearchInput(
                      options: relatedPropertySearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: (title) => onRelatedPropertyFieldSubmitted?.call((title, selectedProperty)),
                    ),
                    SpacingFoundation.verticalSpace16,
                    Expanded(
                      child: UiKitPropertiesCloud(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: relatedProperties?.length ?? 0,
                          itemBuilder: (context, index) {
                            return UiKitCloudChipWithDesc(
                              title: relatedProperties![index].title,
                              onTap: () =>
                                  onSelectedRelatedPropertyTapped?.call((selectedProperty!, relatedProperties![index])),
                              description: '',
                            ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical6);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
