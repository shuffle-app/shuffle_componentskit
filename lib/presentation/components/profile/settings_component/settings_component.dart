import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SettingsComponent extends StatelessWidget {
  final ValueChanged<String?> callback;
  final ValueChanged<String>? onTabSwotched;

  const SettingsComponent({
    Key? key,
    required this.callback,
    this.onTabSwotched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalConfiguration().appConfig.content['profile_settings'];
    final model = ComponentModel.fromJson(config);

    final titleAligment = model.positionModel?.titleAlignment;
    final bodyAligment = model.positionModel?.bodyAlignment;

    final textStyle = context.uiKitTheme?.boldTextTheme;
    const divider = Divider(
      height: 1,
      thickness: 1,
      color: ColorsFoundation.darkNeutral400,
    );
    const double iconWidht = 20.0;

    final Map<String, PropertiesBaseModel> buttons = Map.of(model.content.body?[ContentItemType.button]?.properties ?? {})
        .map((key, value) => MapEntry(key.toUpperCase(), value))
      ..removeWhere((key, value) => value.color != null);

    final Map<String, PropertiesBaseModel> redButtons = Map.of(model.content.body?[ContentItemType.button]?.properties ?? {})
        .map((key, value) => MapEntry(key.toUpperCase(), value))
      ..removeWhere((key, value) => value.color == null);

    final List<BaseUiKitButtonData> btnDataList = [];

    for (var i in buttons.entries) {
      btnDataList.add(BaseUiKitButtonData(
          icon: ImageWidget(
            link: i.value.imageLink,
            color: Colors.white,
            width: iconWidht,
            fit: BoxFit.fitWidth,
          ),
          text: i.key,
          onPressed: () => callback.call(i.value.value)));
    }
    btnDataList.sort((a, b) => buttons[a.text]!.sortNumber!.compareTo(buttons[b.text]!.sortNumber!));

    final List<BaseUiKitButtonData> redBtnDataList = [];

    for (var i in redButtons.entries) {
      redBtnDataList.add(BaseUiKitButtonData(
          icon: ImageWidget(
            link: i.value.imageLink,
            color: i.value.color ?? Colors.red,
            width: iconWidht,
            fit: BoxFit.fitWidth,
          ),
          text: i.key,
          onPressed: () => callback.call(i.value.value)));
    }
    redBtnDataList.sort((a, b) => redButtons[a.text]!.sortNumber!.compareTo(redButtons[b.text]!.sortNumber!));

    final tabs = model.content.body?[ContentItemType.tabBar]?.properties ?? {};

    return Column(children: [
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
      if (tabs.isNotEmpty) ...[
        SpacingFoundation.verticalSpace16,
        UiKitCustomTabBar(
          onTappedTab: (index) => onTabSwotched?.call(tabs.keys.elementAt(index)),
          tabs: tabs.keys.map((e) => UiKitCustomTab(title: e.toUpperCase())).toList(),
        ),
        SpacingFoundation.verticalSpace12,
      ],
      Theme(
          data: ThemeData(textButtonTheme: TextButtonThemeData(style: context.uiKitTheme?.textButtonStyle)),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: bodyAligment.crossAxisAlignment,
              mainAxisAlignment: bodyAligment.mainAxisAlignment,
              children: btnDataList
                  .map(
                    (e) => [context.button(isTextButton: true, data: e), divider],
                  )
                  .expand((element) => element)
                  .toList())),
      Theme(
          data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                  style: context.uiKitTheme?.textButtonStyle
                      .copyWith(foregroundColor: MaterialStateProperty.resolveWith((states) => UiKitColors.error)))),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: bodyAligment.crossAxisAlignment,
              mainAxisAlignment: bodyAligment.mainAxisAlignment,
              children: [
                context.button(isTextButton: true, data: redBtnDataList.first),
                divider,
                context.button(isTextButton: true, data: redBtnDataList.last),
              ]))
    ]).paddingSymmetric(
        horizontal: model.positionModel?.horizontalMargin?.toDouble() ?? 0,
        vertical: model.positionModel?.verticalMargin?.toDouble() ?? 0);
  }
}
