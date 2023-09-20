import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyProfileComponent extends StatelessWidget {
  final ValueChanged<String?> onProfileItemChosen;
  final ValueChanged<String>? onTabSwitched;
  final UiCompanyProfileModel? uiModel;

  const CompanyProfileComponent({
    super.key,
    required this.onProfileItemChosen,
    this.onTabSwitched,
    this.uiModel,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final config = GlobalComponent
        .of(context)
        ?.globalConfiguration
        .appConfig
        .content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['company_profile']);
    final title = model.content.title?[ContentItemType.text]?.properties?.keys.first;
    final titleAlignment = model.positionModel?.titleAlignment;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final iconWidth = 20.0;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final buttons = model.content.body?[ContentItemType.button]?.properties;
    final buttonTypes = buttons?.values.map((e) => e.type).toList() ?? [];
    List<UiKitCustomTab> tabs = [];
    for (var i in buttonTypes) {
      if (tabs
          .indexWhere((element) => element.title == (i?.toUpperCase() ?? ''))
          .isNegative) {
        tabs.add(UiKitCustomTab(title: i?.toUpperCase() ?? ''));
      }
    }
    final sortedButtons = buttons?.entries
        .where((element) => element.value.type?.toUpperCase() == (uiModel?.selectedTab ?? tabs.first.title))
        .map<BaseUiKitButtonData>(
          (value) =>
          BaseUiKitButtonData(
            text: value.key,
            icon: ImageWidget(
              link: value.value.imageLink,
              color: value.value.color ?? Colors.white,
              width: iconWidth,
            ),
            onPressed: () => onProfileItemChosen(value.value.value),
          ),
    )
        .toList();
    sortedButtons?.sort(
          (a, b) => buttons![a.text]!.sortNumber!.compareTo(buttons[b.text]!.sortNumber!),
    );

    return SingleChildScrollView(child: Column(
      crossAxisAlignment: bodyAlignment.crossAxisAlignment,
      children: [
        SizedBox(
          height: MediaQuery
              .viewPaddingOf(context)
              .top + SpacingFoundation.verticalSpacing16,
        ),
        Center(
          child: Text(
            title ?? '',
            style: textTheme?.title1,
          ),
        ),
        SpacingFoundation.verticalSpace24,
        if (tabs.length >= 2)
          UiKitCustomTabBar(
            tabs: tabs,
            onTappedTab: (index) =>
                onTabSwitched?.call(tabs
                    .elementAt(index)
                    .title),
          ),
        ...sortedButtons
            ?.map(
              (e) =>
          [
            SpacingFoundation.verticalSpace4,
            Theme(
              data: ThemeData(
                textButtonTheme: TextButtonThemeData(
                  style: context.uiKitTheme?.textButtonStyle.copyWith(
                    foregroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                        if (buttons?[e.text]?.color == null) {
                          return buttons?[e.text]?.color ?? Colors.white;
                        }

                        return ColorsFoundation.error;
                      },
                    ),
                  ),
                ),
              ),
              child: context.button(
                isTextButton: true,
                data: e,
              ),
            ),
            SpacingFoundation.verticalSpace4,
            if (e != sortedButtons.last)
              const Divider(
                height: 1,
                thickness: 1,
                color: ColorsFoundation.darkNeutral400,
              ),
          ],
        )
            .expand((element) => element)
            .toList() ??
            [],
      ],
    ).paddingSymmetric(horizontal: horizontalMargin));
  }
}
