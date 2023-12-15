import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SettingsComponent extends StatelessWidget {
  final ValueChanged<String>? onTabSwitched;
  final String? selectedContentType;
  final List<UiKitCustomTab>? tabs;
  final List<BaseUiKitButtonData> btnDataList;
  final List<BaseUiKitButtonData> redBtnDataList;

  const SettingsComponent({
    Key? key,
    this.onTabSwitched,
    this.selectedContentType,
    this.tabs,
    required this.btnDataList,
    required this.redBtnDataList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalConfiguration().appConfig.content['profile_settings'];
    final model = ComponentModel.fromJson(config);
    final uiKitTheme = context.uiKitTheme;

    final titleAligment = model.positionModel?.titleAlignment;
    final bodyAligment = model.positionModel?.bodyAlignment;

    final textStyle = context.uiKitTheme?.boldTextTheme;
    const divider = Divider(
      height: 1,
      thickness: 1,
      color: ColorsFoundation.darkNeutral400,
    );

    return Column(
      children: [
        if (model.content.title != null)
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: titleAligment.crossAxisAlignment,
              mainAxisAlignment: titleAligment.mainAxisAlignment,
              children: [
                Text(
                  model.content.title![ContentItemType.text]?.properties?.keys.first ?? 'Settings',
                  style: textStyle?.title1,
                ),
                SpacingFoundation.verticalSpace12
              ]),
        if (tabs != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitCustomTabBar(
            selectedTab: selectedContentType?.toUpperCase(),
            onTappedTab: (index) => onTabSwitched?.call(tabs!.elementAt(index).title.toLowerCase()),
            tabs: tabs!,
          ),
          SpacingFoundation.verticalSpace12,
        ],
        Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: uiKitTheme!.textButtonStyle(uiKitTheme.colorScheme.inversePrimary).copyWith(
                    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                  ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: bodyAligment.crossAxisAlignment,
            mainAxisAlignment: bodyAligment.mainAxisAlignment,
            children: btnDataList
                .map(
                  (e) => [context.button(isTextButton: true, data: e), divider],
                )
                .expand((element) => element)
                .toList(),
          ),
        ),
        Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: context.uiKitTheme?.textButtonStyle(UiKitColors.error).copyWith(
                    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                  ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: bodyAligment.crossAxisAlignment,
            mainAxisAlignment: bodyAligment.mainAxisAlignment,
            children: [
              context.button(isTextButton: true, data: redBtnDataList.first),
              divider,
              context.button(isTextButton: true, data: redBtnDataList.last),
            ],
          ),
        ),
        kBottomNavigationBarHeight.heightBox
      ],
    ).paddingSymmetric(
      horizontal: model.positionModel?.horizontalMargin?.toDouble() ?? 0,
      vertical: model.positionModel?.verticalMargin?.toDouble() ?? 0,
    );
  }
}
