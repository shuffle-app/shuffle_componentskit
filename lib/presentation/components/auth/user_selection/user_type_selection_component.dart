import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UserTypeSelectionComponent extends StatelessWidget {
  final ValueChanged<String>? onUserTypeSelected;

  const UserTypeSelectionComponent({
    super.key,
    this.onUserTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['user_type_selection']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    String title = '';
    if (model.content.title?[ContentItemType.text]?.properties?.isNotEmpty ?? false) {
      title = model.content.title?[ContentItemType.text]?.properties?.keys.first ?? '';
    }
    String subtitle = '';
    if (model.content.subtitle?[ContentItemType.text]?.properties?.isNotEmpty ?? false) {
      subtitle = model.content.subtitle?[ContentItemType.text]?.properties?.keys.first ?? '';
    }
    final redirects = model.content.body?[ContentItemType.redirect]?.properties;
    List<String> redirectsSorted = List<String>.generate(redirects?.length ?? 0, (index) => '');
    redirects?.forEach((key, value) {
      redirectsSorted.insert((value.sortNumber?.toInt() ?? 1) - 1, key);
    });
    final redirectCardWidth = 1.sw * 0.325;
    final redirectCardHeight = redirectCardWidth * 0.923;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top + SpacingFoundation.verticalSpacing16,
            ),
            // if (contentTypeList.first == ContentItemType.text)
            Text(
              title,
              style: boldTextTheme?.titleLarge,
            ),
            SpacingFoundation.verticalSpace16,
            Text(
              subtitle,
              style: boldTextTheme?.subHeadline,
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: SpacingFoundation.horizontalSpacing16,
            runSpacing: SpacingFoundation.verticalSpacing16,
            children: redirectsSorted.where((element) => element.isNotEmpty).map((item) {
              return UiKitVerticalChip(
                size: Size(redirectCardWidth, redirectCardHeight),
                caption: item,
                sign: ImageWidget(link: redirects?[item]?.imageLink ?? ''),
                onTap: () => onUserTypeSelected?.call(item.toLowerCase()),
              );
            }).toList(),
          ),
        ),
      ],
    ).paddingSymmetric(
      horizontal: horizontalMargin,
      vertical: verticalMargin,
    );
  }
}
