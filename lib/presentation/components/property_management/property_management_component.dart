// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shuffle_components_kit/presentation/components/components.dart';
// import 'package:shuffle_uikit/shuffle_uikit.dart';
//
// import '../../../shuffle_components_kit.dart';
//
// class PropertyManagementComponent extends StatefulWidget {
//   const PropertyManagementComponent({
//     super.key,
//     this.onPropertyTypeTapped,
//     required this.allPropertyCategories,
//     this.onAddPropertyTypeTap,
//     this.onEditPropertyTypeTap,
//     this.onDeletePropertyTypeTap,
//     required this.propertySearchOptions,
//     required this.onPropertyFieldSubmitted,
//     required this.basePropertyTypesTap,
//     required this.uniquePropertyTypesTap,
//     required this.onRecentlyAddedPropertyTapped,
//     required this.relatedProperties,
//     required this.selectedPropertyId,
//   });
//
//   final ValueChanged<int>? onPropertyTypeTapped;
//   final List<UiModelCategory> allPropertyCategories;
//   final VoidCallback? onAddPropertyTypeTap;
//   final VoidCallback? onEditPropertyTypeTap;
//   final VoidCallback? onDeletePropertyTypeTap;
//   final Future<List<String>> Function(String) propertySearchOptions;
//   final Future<void> Function(int) basePropertyTypesTap;
//   final Future<UiModelProperty> Function(String) onPropertyFieldSubmitted;
//   final Future<void> Function(int) uniquePropertyTypesTap;
//   final ValueChanged<UiModelRelatedProperty>? onRecentlyAddedPropertyTapped;
//   final List<UiModelRelatedProperty>? relatedProperties;
//
//   final int? selectedPropertyId;
//
//   @override
//   State<PropertyManagementComponent> createState() => _PropertyManagementComponentState();
// }
//
// class _PropertyManagementComponentState extends State<PropertyManagementComponent> {
//   UiModelCategory? selectedCategory;
//   List<UiModelProperty> selectedBaseProperties = [];
//   List<UiModelProperty> selectedUniqueProperties = [];
//   late List<UiModelCategory> allPropertyCategories = widget.allPropertyCategories;
//
//   @override
//   Widget build(BuildContext context) {
//     final uiKitTheme = context.uiKitTheme;
//     return Scaffold(
//       body: UiKitCardWrapper(
//         borderRadius: BorderRadiusFoundation.all16,
//         padding: EdgeInsets.symmetric(
//             horizontal: EdgeInsetsFoundation.horizontal32, vertical: EdgeInsetsFoundation.vertical20),
//         color: uiKitTheme?.colorScheme.surface,
//         child: Row(
//           children: [
//             Expanded(
//               child: PropertiesBorderedBox(
//                 title: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         S.current.ActivityTypes,
//                         overflow: TextOverflow.ellipsis,
//                         style: uiKitTheme?.boldTextTheme.title1,
//                       ),
//                     ),
//                     SpacingFoundation.horizontalSpace16,
//                     context.boxIconButton(
//                       data: BaseUiKitButtonData(
//                         onPressed: widget.onAddPropertyTypeTap,
//                         backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
//                         iconInfo: BaseUiKitButtonIconData(
//                             iconData: ShuffleUiKitIcons.plus,
//                             size: kIsWeb ? 24 : 24.sp,
//                             color: ColorsFoundation.primary200),
//                       ),
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     SpacingFoundation.verticalSpace24,
//                     ...(widget.allPropertyCategories).map((element) {
//                       return PropertiesTypeAnimatedButton(
//                         title: element.title,
//                         onTap: () {
//                           setState(() {
//                             selectedCategory = element;
//                           });
//                         },
//                         isSelected: widget.selectedPropertyId == element.id,
//                       );
//                     })
//                   ],
//                 ),
//               ),
//             ),
//             SpacingFoundation.horizontalSpace32,
//             Expanded(
//               child: PropertiesBorderedBox(
//                 title: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         selectedCategory?.title ?? 'Empty',
//                         overflow: TextOverflow.ellipsis,
//                         style: uiKitTheme?.boldTextTheme.title2,
//                       ),
//                     ),
//                     SpacingFoundation.horizontalSpace16,
//                     context.boxIconButton(
//                       data: BaseUiKitButtonData(
//                         onPressed: widget.onEditPropertyTypeTap,
//                         backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
//                         iconInfo: BaseUiKitButtonIconData(
//                             iconData: ShuffleUiKitIcons.pencil,
//                             size: kIsWeb ? 16 : 16.sp,
//                             color: ColorsFoundation.primary200),
//                       ),
//                     ),
//                     SpacingFoundation.horizontalSpace4,
//                     context.boxIconButton(
//                       data: BaseUiKitButtonData(
//                         onPressed: widget.onDeletePropertyTypeTap,
//                         backgroundColor: ColorsFoundation.danger.withOpacity(0.3),
//                         iconInfo: BaseUiKitButtonIconData(
//                             iconData: ShuffleUiKitIcons.trash,
//                             size: kIsWeb ? 16 : 16.sp,
//                             color: ColorsFoundation.danger),
//                       ),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     SpacingFoundation.verticalSpace24,
//                     Text(
//                       S.current.Properties,
//                       style: uiKitTheme?.boldTextTheme.subHeadline,
//                     ),
//                     SpacingFoundation.verticalSpace12,
//                     PropertiesSearchInput(
//                       options: widget.propertySearchOptions,
//                       showAllOptions: true,
//                       onFieldSubmitted: (value) {
//                         widget.onPropertyFieldSubmitted.call(value).then(
//                           (v) {
//                             selectedCategory = selectedCategory
//                                 ?.copyWith(categoryProperties: [v, ...selectedCategory!.categoryProperties]);
//                             _updateAllPropertyCategories();
//                           },
//                         );
//                       },
//                     ),
//                     SpacingFoundation.verticalSpace12,
//                     UiKitPropertiesCloud(
//                       child: Wrap(
//                               spacing: SpacingFoundation.horizontalSpacing12,
//                               runSpacing: SpacingFoundation.verticalSpacing12,
//                               children:
//                                   (selectedCategory?.categoryProperties.where((e) => !e.unique) ?? []).map((element) {
//                                 return UiKitCloudChip(
//                                   title: element.title,
//                                   onTap: () {
//                                     widget.basePropertyTypesTap.call(element.id!).then(
//                                       (value) {
//                                         selectedCategory = selectedCategory?.copyWith(categoryProperties: [
//                                           ...selectedCategory!.categoryProperties.where(
//                                             (e) => e.id != element.id,
//                                           )
//                                         ]);
//                                         _updateAllPropertyCategories();
//                                       },
//                                     );
//                                   },
//                                 );
//                               }).toList())
//                           .paddingAll(EdgeInsetsFoundation.all24),
//                     ),
//                     SpacingFoundation.verticalSpace12,
//                     UiKitPropertiesCloud(
//                       child: Wrap(
//                               spacing: SpacingFoundation.horizontalSpacing12,
//                               runSpacing: SpacingFoundation.verticalSpacing12,
//                               children:
//                                   (selectedCategory?.categoryProperties.where((e) => e.unique) ?? []).map((element) {
//                                 return UiKitCloudChip(
//                                   title: element.title,
//                                   // selected: element.isSelected,
//                                   onTap: () {
//                                     widget.uniquePropertyTypesTap.call(element.id!).then(
//                                       (value) {
//                                         final uniquePropertyIndex = selectedCategory?.uniqueProperties.indexWhere(
//                                           (e) => e.id == element.id,
//                                         );
//                                         if (uniquePropertyIndex != null && uniquePropertyIndex >= 0) {
//                                           final selectedUniqueProperty =
//                                               selectedCategory?.uniqueProperties[uniquePropertyIndex].copyWith();
//                                           if (selectedUniqueProperty != null) {
//                                             selectedCategory?.uniqueProperties[uniquePropertyIndex] =
//                                                 selectedUniqueProperty;
//                                           }
//                                         }
//                                         _updateAllPropertyCategories();
//                                       },
//                                     );
//                                   },
//                                 );
//                               }).toList())
//                           .paddingAll(EdgeInsetsFoundation.all24),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SpacingFoundation.horizontalSpace32,
//             Expanded(
//               child: PropertiesBorderedBox(
//                 title: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         S.current.RecentlyAdded,
//                         overflow: TextOverflow.ellipsis,
//                         style: uiKitTheme?.boldTextTheme.title2,
//                       ),
//                     ),
//                     SpacingFoundation.horizontalSpace16,
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           S.current.Date,
//                           style: uiKitTheme?.regularTextTheme.labelLarge.copyWith(color: ColorsFoundation.mutedText),
//                         ),
//                         SpacingFoundation.horizontalSpace8,
//                         Icon(
//                           ShuffleUiKitIcons.arrowdown,
//                           size: kIsWeb ? 24 : 24.sp,
//                           color: ColorsFoundation.mutedText,
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     SpacingFoundation.verticalSpace16,
//                     UiKitPropertiesCloud(
//                       child: Wrap(
//                               spacing: SpacingFoundation.horizontalSpacing12,
//                               runSpacing: SpacingFoundation.verticalSpacing12,
//                               children: (widget.relatedProperties ?? []).map((element) {
//                                 return UiKitCloudChip(
//                                   title: element.title,
//                                   onTap: () {
//                                     widget.onRecentlyAddedPropertyTapped?.call(
//                                       element,
//                                     );
//                                   },
//                                 );
//                               }).toList())
//                           .paddingAll(EdgeInsetsFoundation.all24),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _updateAllPropertyCategories() {
//     final selectedCategoryIndex = allPropertyCategories.indexWhere((e) => e.id == selectedCategory?.id);
//     if (selectedCategoryIndex >= 0) {
//       allPropertyCategories[selectedCategoryIndex] = selectedCategory!;
//     }
//     setState(() {});
//   }
// }
