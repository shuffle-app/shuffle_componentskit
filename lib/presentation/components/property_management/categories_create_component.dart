import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../components.dart';

class CategoriesCreateComponent extends StatefulWidget {
  const CategoriesCreateComponent({
    super.key,
    required this.onAddCategory,
    required this.onCategorySelect,
    this.onEditSelectedCategory,
    this.onDeleteSelectedCategory,
    this.isEntertainmentSelected = false,
    required this.propertySearchOptions,
    this.onPropertyFieldSubmitted,
    this.onUniquePropertyEdit,
    this.onUniquePropertyDeleteTap,
    this.onUniquePropertyFieldSubmitted,
    required this.uniquePropertySearchOptions,
    this.onRelatedPropertyFieldSubmitted,
    required this.relatedPropertySearchOptions,
    this.onSelectedRelatedPropertyTapped,
    required this.listCategories,
    this.selectedCategory,
    this.onLoadMoreCategories,
    required this.onChangeType,
  });

  int? get selectedCategoryId => selectedCategory?.id;

  final List<UiModelCategory> listCategories;
  final UiModelCategory? selectedCategory;
  final VoidCallback onAddCategory;
  final VoidCallback onChangeType;
  final VoidCallback? onLoadMoreCategories;
  final ValueChanged<int> onCategorySelect;
  final VoidCallback? onEditSelectedCategory;
  final ValueChanged<UiModelProperty>? onUniquePropertyEdit;
  final VoidCallback? onDeleteSelectedCategory;
  final ValueChanged<UiModelProperty>? onUniquePropertyDeleteTap;
  final ValueChanged<String>? onPropertyFieldSubmitted;
  final ValueChanged<String>? onUniquePropertyFieldSubmitted;
  final ValueChanged<String>? onRelatedPropertyFieldSubmitted;
  final Future<List<String>> Function(String) propertySearchOptions;
  final Future<List<String>> Function(String) uniquePropertySearchOptions;
  final Future<List<String>> Function(String) relatedPropertySearchOptions;
  final ValueChanged<UiModelRelatedProperty>? onSelectedRelatedPropertyTapped;
  final bool isEntertainmentSelected;

  @override
  State<CategoriesCreateComponent> createState() => _CategoriesCreateComponentState();
}

class _CategoriesCreateComponentState extends State<CategoriesCreateComponent> {
  UiModelProperty? selectedProperty;

  @override
  void didUpdateWidget(covariant CategoriesCreateComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      setState(() {
        selectedProperty = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
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
                      Text(
                        widget.isEntertainmentSelected ? S.current.Entertainment : S.current.Business,
                        style: uiKitTheme?.regularTextTheme.labelSmall,
                      ),
                      SpacingFoundation.horizontalSpace16,
                      context.boxIconButton(
                        data: BaseUiKitButtonData(
                          onPressed: widget.onAddCategory,
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
                        widget.onLoadMoreCategories?.call();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.listCategories.length,
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
                        final category = widget.listCategories.elementAt(index);
                        return PropertiesTypeAnimatedButton(
                          title: category.title,
                          onTap: () {
                            widget.onCategorySelect.call(category.id);
                          },
                          isSelected: widget.selectedCategoryId == category.id,
                        );
                      },
                    ),
                  )),
            ),
            Flexible(
              child: PropertiesBorderedBox(
                title: widget.selectedCategory?.icon != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageWidget(
                            link: widget.selectedCategory?.icon ?? '',
                            width: kIsWeb ? 24 : 24.sp,
                            color: uiKitTheme?.themeMode == ThemeMode.light
                                ? ColorsFoundation.surface
                                : ColorsFoundation.lightSurface,
                          ),
                          SpacingFoundation.horizontalSpace4,
                          Expanded(
                            child: Text(
                              widget.selectedCategory?.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: uiKitTheme?.boldTextTheme.title2,
                            ),
                          ),
                          SpacingFoundation.horizontalSpace16,
                          context.boxIconButton(
                            data: BaseUiKitButtonData(
                              onPressed: widget.onEditSelectedCategory,
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
                              onPressed: widget.onDeleteSelectedCategory,
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
                      options: widget.propertySearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: widget.onPropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace12,
                    UiKitPropertiesCloud(
                      child: Wrap(
                              spacing: SpacingFoundation.horizontalSpacing12,
                              runSpacing: SpacingFoundation.verticalSpacing12,
                              children: (widget.selectedCategory?.categoryProperties.where((e) => !e.unique) ?? []).map(
                                (e) {
                                  return UiKitCloudChip(
                                    iconPath: e.icon,
                                    title: e.title,
                                    onTap: () {
                                      setState(() {
                                        selectedProperty = e;
                                      });
                                    },
                                  );
                                },
                              ).toList())
                          .paddingAll(EdgeInsetsFoundation.all24),
                    ),
                    SpacingFoundation.verticalSpace24,
                    Text(
                      S.current.UniqueProperties,
                      style: uiKitTheme?.boldTextTheme.subHeadline,
                    ),
                    SpacingFoundation.verticalSpace12,
                    PropertiesSearchInput(
                      options: widget.uniquePropertySearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: widget.onUniquePropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace12,
                    UiKitPropertiesCloud(
                      child: Column(
                        children: [
                          if (selectedProperty != null && selectedProperty!.unique)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                context.boxIconButton(
                                  data: BaseUiKitButtonData(
                                    onPressed: () => widget.onUniquePropertyEdit?.call(selectedProperty!),
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
                                    onPressed: () => widget.onUniquePropertyDeleteTap?.call(selectedProperty!),
                                    backgroundColor: ColorsFoundation.danger.withOpacity(0.3),
                                    iconInfo: BaseUiKitButtonIconData(
                                        iconData: ShuffleUiKitIcons.trash,
                                        size: kIsWeb ? 16 : 16.sp,
                                        color: ColorsFoundation.danger),
                                  ),
                                ),
                              ],
                            ).paddingAll(EdgeInsetsFoundation.all4),
                          Wrap(
                                  spacing: SpacingFoundation.horizontalSpacing12,
                                  runSpacing: SpacingFoundation.verticalSpacing12,
                                  children:
                                      (widget.selectedCategory?.categoryProperties.where((e) => e.unique) ?? []).map(
                                    (e) {
                                      return UiKitCloudChip(
                                        title: e.title,
                                        onTap: () {
                                          setState(() {
                                            selectedProperty = e;
                                          });
                                        },
                                        iconPath: e.icon,
                                      );
                                    },
                                  ).toList())
                              .paddingOnly(
                                  left: EdgeInsetsFoundation.horizontal20,
                                  right: EdgeInsetsFoundation.horizontal20,
                                  bottom: EdgeInsetsFoundation.vertical20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      options: widget.relatedPropertySearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: widget.onRelatedPropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace16,
                    UiKitPropertiesCloud(
                      child: Column(
                        children: (selectedProperty?.relatedProperties ?? []).map(
                          (e) {
                            return UiKitCloudChipWithDesc(
                              title: e.title,
                              description: e.linkedMindsets.join(', '),
                            ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical6);
                          },
                        ).toList(),
                      ).paddingSymmetric(
                          horizontal: EdgeInsetsFoundation.horizontal20, vertical: EdgeInsetsFoundation.vertical14),
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
