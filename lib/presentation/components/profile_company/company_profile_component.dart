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
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['company_profile']);
    final title = model.content.title?[ContentItemType.text]?.properties?.keys.first;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final iconWidth = 16.h;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    const divider = Divider(
      height: 1,
      thickness: 1,
      color: ColorsFoundation.surface2,
    );
    // final buttons = model.content.body?[ContentItemType.button]?.properties;
    // final buttonTypes = buttons?.values.map((e) => e.type).toList() ?? [];
    List<UiKitCustomTab> tabs = [];
    // for (var i in buttonTypes) {
    //   if (tabs.indexWhere((element) => element.title == (i?.toUpperCase() ?? '')).isNegative) {
    //     tabs.add(UiKitCustomTab(title: i?.toUpperCase() ?? ''));
    //   }
    // }
    // final sortedButtons = buttons?.entries
    //     .where((element) => element.value.type?.toUpperCase() == (uiModel?.selectedTab ?? tabs.first.title))
    //     .map<BaseUiKitButtonData>(
    //   (buttonData) {
    //     final linkIsPath = (buttonData.value.imageLink?.contains('.svg') ?? false) ||
    //         (buttonData.value.imageLink?.contains('.png') ?? false);
    //
    //     return BaseUiKitButtonData(
    //       text: buttonData.key,
    //       iconInfo: BaseUiKitButtonIconData(
    //         iconPath: linkIsPath ? buttonData.value.imageLink : null,
    //         iconData: linkIsPath ? null : GraphicsFoundation.instance.iconFromString(buttonData.value.imageLink ?? ''),
    //         color: buttonData.value.color ?? context.uiKitTheme?.colorScheme.inverseSurface,
    //         size: iconWidth,
    //       ),
    //       onPressed: () => onProfileItemChosen(buttonData.value.value),
    //     );
    //   },
    // ).toList();
    // sortedButtons?.sort(
    //   (a, b) => buttons![a.text]!.sortNumber!.compareTo(buttons[b.text]!.sortNumber!),
    // );

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: bodyAlignment.crossAxisAlignment,
      children: [
        SizedBox(
          height: MediaQuery.viewPaddingOf(context).top + SpacingFoundation.verticalSpacing16,
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
            onTappedTab: (index) => onTabSwitched?.call(tabs.elementAt(index).title),
          ),
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.building,
              size: iconWidth,
            ),
            text: S.current.EditProfile.toUpperCase(),
            onPressed: () => onProfileItemChosen('edit_profile'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.booking,
              size: iconWidth,
            ),
            text: S.current.Bookings(2).toUpperCase(),
            onPressed: () => onProfileItemChosen('bookings'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.label,
              size: iconWidth,
            ),
            text: S.current.AddPromotion.toUpperCase(),
            onPressed: () => onProfileItemChosen('promotion'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.archive,
              size: iconWidth,
            ),
            text: S.current.Archive.toUpperCase(),
            onPressed: () => onProfileItemChosen('archive'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.warning,
              size: iconWidth,
            ),
            text: S.current.PrivacyPolicy.toUpperCase(),
            onPressed: () => onProfileItemChosen('privacy'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.flag,
              size: iconWidth,
            ),
            text: S.current.TermsOfService.toUpperCase(),
            onPressed: () => onProfileItemChosen('terms'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconWidget: ImageWidget(svgAsset: GraphicsFoundation.instance.svg.lifebuoy,width: iconWidth,),
            // iconInfo: BaseUiKitButtonIconData(
            //
            //   size: iconWidth,
            // ),
            text: S.current.Support.toUpperCase(),
            onPressed: () => onProfileItemChosen('support'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.logout,
              size: iconWidth,
              color: ColorsFoundation.error,
            ),
            text: S.current.Exit.toUpperCase(),
            textColor: ColorsFoundation.error,
            onPressed: () => onProfileItemChosen('exit'),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        divider,
        SpacingFoundation.verticalSpace16,
        UiKitInlineButton(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.profiledelete,
              size: iconWidth,
              color: ColorsFoundation.error,
            ),
            textColor: ColorsFoundation.error,
            text: S.current.DeleteCompany.toUpperCase(),
            onPressed: () => onProfileItemChosen('delete'),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: horizontalMargin));
  }
}
