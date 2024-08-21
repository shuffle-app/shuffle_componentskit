import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import '../../../shuffle_components_kit.dart';

class MindsetsManageComponent extends StatefulWidget {
  const MindsetsManageComponent({
    super.key,
    required this.onAddMindset,
    required this.onMindsetSelect,
    this.onEditSelectedMindset,
    this.onDeleteSelectedMindset,
    required this.tagSearchOptions,
    this.onPropertyFieldSubmitted,
    this.onTagEditTap,
    this.onTagDeleteTap,
    required this.listMindsets,
    this.selectedMindset,
  });

  int? get selectedMindsetId => selectedMindset?.id;

  final List<UiModelCategory> listMindsets;
  final UiModelCategory? selectedMindset;
  final VoidCallback onAddMindset;
  final ValueChanged<int> onMindsetSelect;
  final VoidCallback? onEditSelectedMindset;
  final VoidCallback? onDeleteSelectedMindset;
  final ValueChanged<UiModelProperty>? onTagDeleteTap;
  final ValueChanged<UiModelProperty>? onTagEditTap;
  final ValueChanged<String>? onPropertyFieldSubmitted;
  final Future<List<String>> Function(String) tagSearchOptions;

  @override
  State<MindsetsManageComponent> createState() => _MindsetsManageComponentState();
}

class _MindsetsManageComponentState extends State<MindsetsManageComponent> {
  UiModelProperty? selectedTag;

  @override
  void didUpdateWidget(covariant MindsetsManageComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMindset != oldWidget.selectedMindset ||
        widget.selectedMindset?.uniqueProperties.length != oldWidget.selectedMindset?.uniqueProperties.length ||
        widget.selectedMindset?.baseProperties.length != oldWidget.selectedMindset?.baseProperties.length) {}
    setState(() {
      selectedTag = null;
    });
    if (selectedTag != null &&
        selectedTag?.relatedProperties?.length !=
            (selectedTag!.unique
                    ? widget.selectedMindset?.uniqueProperties.firstWhere((e) => e.id == selectedTag?.id)
                    : widget.selectedMindset?.baseProperties.firstWhere((e) => e.id == selectedTag?.id))
                ?.relatedProperties
                ?.length) {
      setState(() {
        selectedTag = (selectedTag!.unique
            ? widget.selectedMindset?.uniqueProperties.firstWhere((e) => e.id == selectedTag?.id)
            : widget.selectedMindset?.baseProperties.firstWhere((e) => e.id == selectedTag?.id));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiKitTheme = context.uiKitTheme;
    debugPrint('CategoriesCreateComponent build here with selectedProperty: ${selectedTag?.title}');

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
                        S.current.ActivityTypes,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title1,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace16,
                    context.boxIconButton(
                      data: BaseUiKitButtonData(
                        onPressed: widget.onAddMindset,
                        backgroundColor: ColorsFoundation.primary200.withOpacity(0.3),
                        iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.plus,
                            size: kIsWeb ? 24 : 24.sp,
                            color: ColorsFoundation.primary200),
                      ),
                    )
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.listMindsets.length,
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
                    final category = widget.listMindsets.elementAt(index);
                    return PropertiesTypeAnimatedButton(
                      title: category.title,
                      onTap: () {
                        widget.onMindsetSelect.call(category.id);
                      },
                      isSelected: widget.selectedMindsetId == category.id,
                    );
                  },
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace16,
            Flexible(
              child: PropertiesBorderedBox(
                title: widget.selectedMindset?.icon != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageWidget(
                            link: widget.selectedMindset?.icon ?? '',
                            width: kIsWeb ? 24 : 24.sp,
                            color: uiKitTheme?.themeMode == ThemeMode.light
                                ? ColorsFoundation.surface
                                : ColorsFoundation.lightSurface,
                          ),
                          SpacingFoundation.horizontalSpace4,
                          Expanded(
                            child: Text(
                              widget.selectedMindset?.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: uiKitTheme?.boldTextTheme.title2,
                            ),
                          ),
                          SpacingFoundation.horizontalSpace16,
                          context.boxIconButton(
                            data: BaseUiKitButtonData(
                              onPressed: widget.onEditSelectedMindset,
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
                              onPressed: widget.onDeleteSelectedMindset,
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
                      S.current.Properties,
                      style: uiKitTheme?.boldTextTheme.subHeadline,
                    ),
                    SpacingFoundation.verticalSpace12,
                    PropertiesSearchInput(
                      options: widget.tagSearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: widget.onPropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace12,
                    UiKitPropertiesCloud(
                      child: Column(children: [
                        if (selectedTag != null && selectedTag!.unique)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              context.boxIconButton(
                                data: BaseUiKitButtonData(
                                  onPressed: () => widget.onTagEditTap?.call(selectedTag!),
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
                                  onPressed: () => widget.onTagDeleteTap?.call(selectedTag!),
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
                            children: (widget.selectedMindset?.categoryProperties.where((e) => !e.unique) ?? []).map(
                              (e) {
                                return UiKitCloudChip(
                                  iconPath: e.icon,
                                  title: e.title,
                                  selected: e == selectedTag,
                                  onTap: () {
                                    setState(() {
                                      if (selectedTag == e) {
                                        selectedTag = null;
                                      } else {
                                        selectedTag = e;
                                      }
                                    });
                                  },
                                );
                              },
                            ).toList())
                      ]).paddingAll(EdgeInsetsFoundation.all24),
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
                        S.current.RecentlyAdded,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title2,
                      ),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UnderDevelopment()
                    // PropertiesSearchInput(
                    //   options: widget.relatedPropertySearchOptions,
                    //   showAllOptions: true,
                    //   onFieldSubmitted: (title) => widget.onRelatedPropertyFieldSubmitted?.call((title, selectedTag)),
                    // ),
                    // SpacingFoundation.verticalSpace16,
                    // UiKitPropertiesCloud(
                    //   child: Column(
                    //     children: (selectedTag?.relatedProperties ?? []).map(
                    //       (e) {
                    //         return UiKitCloudChipWithDesc(
                    //           title: e.title,
                    //           description: e.linkedMindsets.join(', '),
                    //         ).paddingSymmetric(vertical: EdgeInsetsFoundation.vertical6);
                    //       },
                    //     ).toList(),
                    //   ).paddingSymmetric(
                    //       horizontal: EdgeInsetsFoundation.horizontal20, vertical: EdgeInsetsFoundation.vertical14),
                    // ),
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
