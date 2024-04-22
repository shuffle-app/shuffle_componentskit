import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UserTypeSelectionComponent extends StatefulWidget {
  final ValueChanged<String>? onUserTypeSelected;
  final UiUserTypeSelectionModel uiModel;

  const UserTypeSelectionComponent({
    super.key,
    this.onUserTypeSelected,
    required this.uiModel,
  });

  @override
  State<UserTypeSelectionComponent> createState() => _UserTypeSelectionComponentState();
}

class _UserTypeSelectionComponentState extends State<UserTypeSelectionComponent> {
  late CustomBackgroundSwitchOption selectedOption = widget.uiModel.options.last;

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['user_type_selection']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.viewPaddingOf(context).top + SpacingFoundation.verticalSpacing16,
            ),
            // if (contentTypeList.first == ContentItemType.text)
            Text(
              S.current.Welcome,
              style: boldTextTheme?.titleLarge,
            ),
            SpacingFoundation.verticalSpace16,
            Text(
              S.current.UserTypeSelectionPrompt,
              style: boldTextTheme?.subHeadline,
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: UiKitSwitchWithCustomBackground(
            firstOption: CustomBackgroundSwitchOption(
              title: widget.uiModel.options.first.title,
              iconLink: widget.uiModel.options.first.iconLink,
              value: widget.uiModel.options.first.value,
            ),
            secondOption: CustomBackgroundSwitchOption(
              title: widget.uiModel.options.last.title,
              iconLink: widget.uiModel.options.last.iconLink,
              value: widget.uiModel.options.last.value,
            ),
            selectedOption: selectedOption,
            onChanged: (value) {
              setState(() => selectedOption = value);
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 1.sw,
            child: context.button(
              data: BaseUiKitButtonData(
                text: S.of(context).Next.toUpperCase(),
                onPressed: () => widget.onUserTypeSelected?.call(selectedOption.value.toLowerCase()),
              ),
            ),
          ),
        ).paddingOnly(bottom: EdgeInsetsFoundation.vertical4),
      ],
    ).paddingSymmetric(
      horizontal: horizontalMargin,
      vertical: verticalMargin,
    );
  }
}
