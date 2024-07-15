import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../components.dart';

class CategoriesCreateComponent extends StatelessWidget {
  const CategoriesCreateComponent(
      {super.key,
      required this.onAddCategoriesTap,
      required this.onCategoryTypeAddTap,
      required this.onCategoryPropertyTypeButtonTap,
      this.onEditCategoryTypeTap,
      this.onDeleteCategoryTypeTap,
      required this.propertySearchOptions,
      this.onPropertyFieldSubmitted,
      this.onSelectedPropertyTapped,
      this.onUniquePropertyEditTap,
      this.onUniquePropertyDeleteTap,
      this.onUniquePropertyFieldSubmitted,
      required this.uniquePropertySearchOptions,
      this.onSelectedUniquePropertyTapped,
      this.onRelatedPropertyFieldSubmitted,
      required this.relatedPropertySearchOptions,
      this.onSelectedRelatedPropertyTapped,
      required this.entertainmentCategories,
      required this.businessCategories,
      this.selectedCategoryType,
      this.baseProperties,
      this.uniqueProperties,
      this.relatedProperties});

  final List<UiModelCategoryParent> entertainmentCategories;
  final List<UiModelRelatedProperties>? relatedProperties;
  final List<UiModelCategoryParent> businessCategories;
  final List<UiModelProperty>? baseProperties;
  final List<UiModelProperty>? uniqueProperties;
  final UiModelCategoryParent? selectedCategoryType;
  final VoidCallback onAddCategoriesTap;
  final VoidCallback onCategoryTypeAddTap;
  final ValueChanged<int> onCategoryPropertyTypeButtonTap;
  final VoidCallback? onEditCategoryTypeTap;
  final VoidCallback? onUniquePropertyEditTap;
  final VoidCallback? onDeleteCategoryTypeTap;
  final VoidCallback? onUniquePropertyDeleteTap;
  final ValueChanged<String>? onPropertyFieldSubmitted;
  final ValueChanged<String>? onUniquePropertyFieldSubmitted;
  final ValueChanged<String>? onRelatedPropertyFieldSubmitted;
  final Future<List<String>> Function(String) propertySearchOptions;
  final Future<List<String>> Function(String) uniquePropertySearchOptions;
  final Future<List<String>> Function(String) relatedPropertySearchOptions;
  final ValueChanged<UiModelProperty>? onSelectedPropertyTapped;
  final ValueChanged<UiModelProperty>? onSelectedUniquePropertyTapped;
  final ValueChanged<UiModelRelatedProperties>? onSelectedRelatedPropertyTapped;

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
            Expanded(
              child: SingleChildScrollView(
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
                      context.boxIconButton(
                        data: BaseUiKitButtonData(
                          onPressed: onAddCategoriesTap,
                          backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
                          iconInfo: BaseUiKitButtonIconData(
                              iconData: ShuffleUiKitIcons.plus,
                              size: kIsWeb ? 24 : 24.sp,
                              color: ColorsFoundation.primary200),
                        ),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: uiKitTheme?.colorScheme.darkNeutral500.withOpacity(0.24),
                        thickness: 2,
                      ),
                      SpacingFoundation.verticalSpace16,
                      Text(
                        S.current.Entertainment,
                        style: uiKitTheme?.regularTextTheme.labelSmall,
                      ),
                      SpacingFoundation.verticalSpace16,
                      ...entertainmentCategories.map(
                        (e) {
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
                          return PropertiesTypeAnimatedButton(
                            title: e.categoryTitle,
                            onTap: () {
                              onCategoryPropertyTypeButtonTap.call(e.categoryId);
                            },
                          );
                        },
                      ),
                      Divider(
                        color: uiKitTheme?.colorScheme.darkNeutral500.withOpacity(0.24),
                        thickness: 2,
                      ),
                      SpacingFoundation.verticalSpace16,
                      Text(
                        S.current.Business,
                        style: uiKitTheme?.regularTextTheme.labelSmall,
                      ),
                      SpacingFoundation.verticalSpace16,
                      ...businessCategories.map(
                        (e) {
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
                          return PropertiesTypeAnimatedButton(
                            title: e.categoryTitle,
                            onTap: () {
                              onCategoryPropertyTypeButtonTap.call(e.categoryId);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: PropertiesBorderedBox(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageWidget(
                        link: selectedCategoryType?.iconPath ?? '',
                        width: kIsWeb ? 24 : 24.sp,
                        color: uiKitTheme?.themeMode == ThemeMode.light
                            ? ColorsFoundation.surface
                            : ColorsFoundation.lightSurface,
                      ),
                      SpacingFoundation.horizontalSpace4,
                      Expanded(
                        child: Text(
                          selectedCategoryType?.categoryTitle ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: uiKitTheme?.boldTextTheme.title2,
                        ),
                      ),
                      SpacingFoundation.horizontalSpace16,
                      context.boxIconButton(
                        data: BaseUiKitButtonData(
                          onPressed: onEditCategoryTypeTap,
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
                          onPressed: onDeleteCategoryTypeTap,
                          backgroundColor: ColorsFoundation.danger.withOpacity(0.3),
                          iconInfo: BaseUiKitButtonIconData(
                              iconData: ShuffleUiKitIcons.trash,
                              size: kIsWeb ? 16 : 16.sp,
                              color: ColorsFoundation.danger),
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Wrap(
                                spacing: SpacingFoundation.horizontalSpacing12,
                                runSpacing: SpacingFoundation.verticalSpacing12,
                                children: (baseProperties ?? []).map(
                                  (e) {
                                    return UiKitCloudChip(
                                      iconPath: e.iconPath,
                                      title: e.title,
                                      onTap: () {
                                        onSelectedPropertyTapped?.call(e);
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
                        options: uniquePropertySearchOptions,
                        showAllOptions: true,
                        onFieldSubmitted: onUniquePropertyFieldSubmitted,
                      ),
                      SpacingFoundation.verticalSpace12,
                      UiKitPropertiesCloud(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                context.boxIconButton(
                                  data: BaseUiKitButtonData(
                                    onPressed: onUniquePropertyEditTap,
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
                                    onPressed: onUniquePropertyDeleteTap,
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
                                    children: (uniqueProperties ?? []).map(
                                      (e) {
                                        return UiKitCloudChip(
                                          title: e.title,
                                          onTap: () {
                                            onSelectedUniquePropertyTapped?.call(e);
                                          },
                                          iconPath: e.iconPath,
                                          isSelectable: true,
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
            ),
            Expanded(
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
                      onFieldSubmitted: onRelatedPropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace16,
                    UiKitPropertiesCloud(
                      child: Column(
                        children: (relatedProperties ?? []).map(
                          (e) {
                            return UiKitCloudChipWithDesc(
                              title: e.title,
                              description: e.linkedMainSets.join(', '),
                              onTap: () {
                                onSelectedRelatedPropertyTapped?.call(e);
                              },
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
