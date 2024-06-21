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
      this.onSelectedRelatedPropertyTapped});

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
  final ValueChanged<UiModelPropertyType>? onSelectedPropertyTapped;
  final ValueChanged<UiModelPropertyType>? onSelectedUniquePropertyTapped;
  final ValueChanged<UiModelPropertyType>? onSelectedRelatedPropertyTapped;

  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
    return Scaffold(
      body: UiKitCardWrapper(
        borderRadius: BorderRadiusFoundation.all16,
        padding: EdgeInsets.symmetric(
            horizontal: EdgeInsetsFoundation.horizontal32,
            vertical: EdgeInsetsFoundation.vertical20),
        color: uiKitTheme?.colorScheme.surface,
        child: Row(
          children: [
            // Expanded(
            //   child: PropertiesBorderedBox(
            //     title: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Expanded(
            //           child: Text(
            //             'Categories',
            //             overflow: TextOverflow.ellipsis,
            //             style: uiKitTheme?.boldTextTheme.title1,
            //           ),
            //         ),
            //         SpacingFoundation.horizontalSpace16,
            //         context.boxIconButton(
            //           data: BaseUiKitButtonData(
            //             onPressed: onAddCategoriesTap,
            //             backgroundColor:
            //                 ColorsFoundation.primary200.withOpacity(0.3),
            //             iconInfo: BaseUiKitButtonIconData(
            //                 iconData: ShuffleUiKitIcons.plus,
            //                 size: kIsWeb ? 24 : 24.sp,
            //                 color: ColorsFoundation.primary200),
            //           ),
            //         )
            //       ],
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Divider(
            //               color: uiKitTheme?.colorScheme.darkNeutral500
            //                   .withOpacity(0.24),
            //               thickness: 2,
            //             ),
            //             SpacingFoundation.verticalSpace16,
            //             Text(
            //               'Entertaiment',
            //               style: uiKitTheme?.regularTextTheme.labelSmall,
            //             ),
            //             SpacingFoundation.verticalSpace16,
            //             UiKitExpansionTileWithIconButton(
            //               title: 'Foodie and drink',
            //               onTap: onCategoryTypeAddTap,
            //               children: List.generate(
            //                 5,
            //                 (index) {
            //                   return PropertiesTypeAnimatedButton(
            //                     title: 'Index ==> $index',
            //                     onTap: onCategoryPropertyTypeButtonTap,
            //                   );
            //                 },
            //               ),
            //             )
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: PropertiesBorderedBox(
            //     title: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Icon(
            //           ShuffleUiKitIcons.restaurant,
            //           size: kIsWeb ? 24 : 24.sp,
            //           color: uiKitTheme?.themeMode == ThemeMode.light
            //               ? ColorsFoundation.surface
            //               : ColorsFoundation.lightSurface,
            //         ),
            //         SpacingFoundation.horizontalSpace4,
            //         Expanded(
            //           child: Text(
            //             'Restaurants',
            //             overflow: TextOverflow.ellipsis,
            //             style: uiKitTheme?.boldTextTheme.title2,
            //           ),
            //         ),
            //         SpacingFoundation.horizontalSpace16,
            //         context.boxIconButton(
            //           data: BaseUiKitButtonData(
            //             onPressed: onEditCategoryTypeTap,
            //             backgroundColor:
            //                 ColorsFoundation.primary200.withOpacity(0.3),
            //             iconInfo: BaseUiKitButtonIconData(
            //                 iconData: ShuffleUiKitIcons.pencil,
            //                 size: kIsWeb ? 16 : 16.sp,
            //                 color: ColorsFoundation.primary200),
            //           ),
            //         ),
            //         SpacingFoundation.horizontalSpace4,
            //         context.boxIconButton(
            //           data: BaseUiKitButtonData(
            //             onPressed: onDeleteCategoryTypeTap,
            //             backgroundColor:
            //                 ColorsFoundation.danger.withOpacity(0.3),
            //             iconInfo: BaseUiKitButtonIconData(
            //                 iconData: ShuffleUiKitIcons.trash,
            //                 size: kIsWeb ? 16 : 16.sp,
            //                 color: ColorsFoundation.danger),
            //           ),
            //         ),
            //       ],
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           S.current.BaseProperties,
            //           style: uiKitTheme?.boldTextTheme.subHeadline,
            //         ),
            //         SpacingFoundation.verticalSpace12,
            //         PropertiesSearchInput(
            //           options: propertySearchOptions,
            //           showAllOptions: true,
            //           onFieldSubmitted: onPropertyFieldSubmitted,
            //         ),
            //         SpacingFoundation.verticalSpace12,
            //         UiKitPropertiesCloud(
            //           child: Wrap(
            //             spacing: SpacingFoundation.horizontalSpacing12,
            //             runSpacing: SpacingFoundation.verticalSpacing12,
            //             children: List.generate(
            //               10,
            //               (index) {
            //                 return UiKitCloudChip(
            //                   title: 'Index ==> $index',
            //                   onTap: () {
            //                     // onSelectedPropertyTapped?.call(element);
            //                   },
            //                 );
            //               },
            //             ),
            //           ).paddingAll(EdgeInsetsFoundation.all24),
            //         ),
            //         SpacingFoundation.verticalSpace24,
            //         Text(
            //           S.current.UniqueProperties,
            //           style: uiKitTheme?.boldTextTheme.subHeadline,
            //         ),
            //         SpacingFoundation.verticalSpace12,
            //         PropertiesSearchInput(
            //           options: uniquePropertySearchOptions,
            //           showAllOptions: true,
            //           onFieldSubmitted: onUniquePropertyFieldSubmitted,
            //         ),
            //         SpacingFoundation.verticalSpace12,
            //         UiKitPropertiesCloud(
            //           child: Column(
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: [
            //                   context.boxIconButton(
            //                     data: BaseUiKitButtonData(
            //                       onPressed: onUniquePropertyEditTap,
            //                       backgroundColor: ColorsFoundation.primary200
            //                           .withOpacity(0.3),
            //                       iconInfo: BaseUiKitButtonIconData(
            //                           iconData: ShuffleUiKitIcons.pencil,
            //                           size: kIsWeb ? 16 : 16.sp,
            //                           color: ColorsFoundation.primary200),
            //                     ),
            //                   ),
            //                   SpacingFoundation.horizontalSpace4,
            //                   context.boxIconButton(
            //                     data: BaseUiKitButtonData(
            //                       onPressed: onUniquePropertyDeleteTap,
            //                       backgroundColor:
            //                           ColorsFoundation.danger.withOpacity(0.3),
            //                       iconInfo: BaseUiKitButtonIconData(
            //                           iconData: ShuffleUiKitIcons.trash,
            //                           size: kIsWeb ? 16 : 16.sp,
            //                           color: ColorsFoundation.danger),
            //                     ),
            //                   ),
            //                 ],
            //               ).paddingAll(EdgeInsetsFoundation.all4),
            //               Wrap(
            //                     spacing: SpacingFoundation.horizontalSpacing12,
            //                     runSpacing: SpacingFoundation.verticalSpacing12,
            //                 children: List.generate(
            //                   10,
            //                   (index) {
            //                     return UiKitCloudChip(
            //                       title: 'Index ==> $index',
            //                       onTap: () {
            //                         // onSelectedUniquePropertyTapped.call();
            //                       },
            //                       icon: ShuffleUiKitIcons.heartoutline,
            //                       isSelectable: true,
            //                     );
            //                   },
            //                 ),
            //               ).paddingOnly(
            //                   left: EdgeInsetsFoundation.horizontal20,
            //                   right: EdgeInsetsFoundation.horizontal20,
            //                   bottom: EdgeInsetsFoundation.vertical20),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Expanded(
              child: PropertiesBorderedBox(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Related personal properties',
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
                        children: List.generate(
                          4,
                          (index) {
                            return UiKitCloudChipWithDesc(
                              title: 'Index ==> $index',
                              description: 'Index ==> $index desc',
                              onTap: () {
                                // onSelectedRelatedPropertyTapped?.call();
                              },
                            ).paddingSymmetric(
                                vertical: EdgeInsetsFoundation.vertical6);
                          },
                        ),
                      ).paddingSymmetric(
                          horizontal: EdgeInsetsFoundation.horizontal20,
                          vertical: EdgeInsetsFoundation.vertical14),
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
