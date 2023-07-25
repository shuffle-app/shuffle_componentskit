import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UserTypeSelectionComponent extends StatelessWidget {
  final UiUserTypeSelectionModel uiModel;
  final ValueChanged<String>? onUserTypeSelected;

  const UserTypeSelectionComponent({
    super.key,
    required this.uiModel,
    this.onUserTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['user_type_selection']);
    List<ContentBaseModel> contents = [];
    List<ContentItemType> contentTypeList = [];
    if (model.content.title != null) {
      contents = model.content.title!.values.toList();
      contentTypeList = model.content.title!.keys.toList();
    }

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
            if (contentTypeList.first == ContentItemType.text)
              Text(
                'Welcome',
                style: boldTextTheme?.titleLarge,
              ),
            SpacingFoundation.verticalSpace16,
            Text(
              'Select the type of account you would like to create',
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
            children: model.content.body?[ContentItemType.singleSelect]?.body?[ContentItemType.singleSelect]?.properties?.entries
                    .map<Widget>(
                      (e) => UiKitVerticalChip(
                        caption: e.key ?? '',
                        sign: ImageWidget(link: e.value.imageLink ?? ''),
                        onTap: () => onUserTypeSelected?.call(e.key.toLowerCase() ?? ''),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16);
  }
}
