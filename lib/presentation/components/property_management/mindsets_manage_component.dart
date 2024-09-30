import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import '../../../shuffle_components_kit.dart';

class MindsetsManageComponent extends StatelessWidget {
  const MindsetsManageComponent({
    super.key,
    required this.onAddMindset,
    required this.onMindsetSelect,
    this.onEditSelectedMindset,
    this.onRecentTagAssign,
    this.onDeleteSelectedMindset,
    required this.tagSearchOptions,
    this.onPropertyFieldSubmitted,
    this.onTagEditTap,
    this.onTagDeleteTap,
    required this.listMindsets,
    this.selectedMindset,
    this.recentlyAddedTags = const [],
    this.listTags,
    this.selectedTag,
    required this.onTagSelect,
  });

  int? get selectedMindsetId => selectedMindset?.id;

  final List<UiKitTag> listMindsets;
  final List<UiKitTag>? listTags;
  final UiKitTag? selectedMindset;
  final UiKitTag? selectedTag;
  final VoidCallback onAddMindset;
  final ValueChanged<int> onMindsetSelect;
  final ValueChanged<int> onTagSelect;
  final VoidCallback? onEditSelectedMindset;
  final VoidCallback? onDeleteSelectedMindset;
  final ValueChanged<UiKitTag>? onTagDeleteTap;
  final ValueChanged<UiKitTag>? onTagEditTap;
  final ValueChanged<UiKitTag>? onRecentTagAssign;
  final ValueChanged<String>? onPropertyFieldSubmitted;
  final Future<List<String>> Function(String) tagSearchOptions;
  final List<UiKitTag> recentlyAddedTags;

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
                        S.current.ActivityTypes,
                        overflow: TextOverflow.ellipsis,
                        style: uiKitTheme?.boldTextTheme.title1,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace16,
                    context.boxIconButton(
                      data: BaseUiKitButtonData(
                        onPressed: onAddMindset,
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
                  itemCount: listMindsets.length,
                  itemBuilder: (context, index) {
                    final mindset = listMindsets.elementAt(index);
                    return PropertiesTypeAnimatedButton(
                      title: mindset.title,
                      onTap: () {
                        onMindsetSelect.call(mindset.id!);
                      },
                      isSelected: selectedMindsetId == mindset.id,
                    );
                  },
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace16,
            Flexible(
              child: PropertiesBorderedBox(
                title: selectedMindset != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageWidget(
                            link: selectedMindset?.icon ?? '',
                            width: kIsWeb ? 24 : 24.sp,
                            color: uiKitTheme?.themeMode == ThemeMode.light
                                ? ColorsFoundation.surface
                                : ColorsFoundation.lightSurface,
                          ),
                          SpacingFoundation.horizontalSpace4,
                          Expanded(
                            child: Text(
                              selectedMindset?.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: uiKitTheme?.boldTextTheme.title2,
                            ),
                          ),
                          SpacingFoundation.horizontalSpace16,
                          context.boxIconButton(
                            data: BaseUiKitButtonData(
                              onPressed: onEditSelectedMindset,
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
                              onPressed: onDeleteSelectedMindset,
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
                      options: tagSearchOptions,
                      showAllOptions: true,
                      onFieldSubmitted: onPropertyFieldSubmitted,
                    ),
                    SpacingFoundation.verticalSpace12,
                    UiKitPropertiesCloud(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (selectedTag != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  context.boxIconButton(
                                    data: BaseUiKitButtonData(
                                      onPressed: () => onTagEditTap?.call(selectedTag!),
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
                                      onPressed: () => onTagDeleteTap?.call(selectedTag!),
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
                                children: (listTags ?? []).map(
                                  (e) {
                                    return UiKitCloudChip(
                                      iconPath: e.icon,
                                      title: e.title,
                                      selected: e == selectedTag,
                                      onTap: () {
                                        onTagSelect.call(e.id!);
                                      },
                                    );
                                  },
                                ).toList())
                          ]),
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
                  child: Wrap(
                      spacing: SpacingFoundation.horizontalSpacing12,
                      runSpacing: SpacingFoundation.verticalSpacing12,
                      children: recentlyAddedTags
                          .map((e) => UiKitCloudChip(
                                iconPath: e.icon,
                                title: e.title,
                                onTap: () => onRecentTagAssign?.call(e),
                              ))
                          .toList())),
            ),
          ],
        ),
      ),
    );
  }
}
