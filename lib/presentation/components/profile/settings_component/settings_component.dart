import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SettingsComponent extends StatelessWidget {
  final ValueChanged<int>? onTabSwitched;
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
      color: ColorsFoundation.surface2,
    );

    return Column(
      children: [
        Text(
          S.current.Settings,
          style: textStyle?.title1,
        ),
        SpacingFoundation.verticalSpace12,
        if (tabs != null) ...[
          SpacingFoundation.verticalSpace16,
          UiKitCustomTabBar(
            selectedTab: selectedContentType,
            onTappedTab: (index) => onTabSwitched?.call(index),
            tabs: tabs!,
          ),
          SpacingFoundation.verticalSpace12,
        ],
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: bodyAligment.crossAxisAlignment,
          mainAxisAlignment: bodyAligment.mainAxisAlignment,
          children: btnDataList
              .map(
                (e) => [
                  _InlineButton(data: e),
                  SpacingFoundation.verticalSpace16,
                  divider,
                  SpacingFoundation.verticalSpace16,
                ],
              )
              .expand((element) => element)
              .toList(),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: bodyAligment.crossAxisAlignment,
          mainAxisAlignment: bodyAligment.mainAxisAlignment,
          children: [
            _InlineButton(data: redBtnDataList.first),
            SpacingFoundation.verticalSpace16,
            divider,
            SpacingFoundation.verticalSpace16,
            _InlineButton(data: redBtnDataList.last),
            SpacingFoundation.verticalSpace16,
          ],
        ),
        kBottomNavigationBarHeight.heightBox
      ],
    ).paddingSymmetric(
      horizontal: model.positionModel?.horizontalMargin?.toDouble() ?? 0,
      vertical: model.positionModel?.verticalMargin?.toDouble() ?? 0,
    );
  }
}

class _InlineButton extends StatelessWidget {
  final BaseUiKitButtonData data;

  const _InlineButton({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.uiKitTheme?.colorScheme;
    final textStyle = context.uiKitTheme?.boldTextTheme;

    return GestureDetector(
      onTap: data.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          data.iconWidget ??
              ImageWidget(
                iconData: data.iconInfo?.iconData,
                link: data.iconInfo?.iconPath,
                color: data.iconInfo?.color ?? colorScheme?.inverseSurface,
                height: data.iconInfo?.size,
                fit: BoxFit.fitHeight,
              ),
          SpacingFoundation.horizontalSpace12,
          Expanded(
            child: Text(
              data.text ?? '',
              style: textStyle?.title2.copyWith(
                overflow: TextOverflow.ellipsis,
                color: data.textColor ?? colorScheme?.inverseSurface,
              ),
            ),
          )
        ],
      ),
    );
  }
}
