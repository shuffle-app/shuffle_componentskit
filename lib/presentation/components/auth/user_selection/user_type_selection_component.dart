import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/auth/user_selection/ui_user_type_selection_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UserTypeSelectionComponent extends StatelessWidget {
  final UiUserTypeSelectionModel model;
  final ValueChanged<String>? onUserTypeSelected;

  const UserTypeSelectionComponent({
    super.key,
    required this.model,
    this.onUserTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

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
            Text(
              model.pageTitle ?? '',
              style: boldTextTheme?.titleLarge,
            ),
            SpacingFoundation.verticalSpace16,
            Text(
              model.pageBodyText ?? '',
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
            children: model.userTypes
                    ?.map<Widget>(
                      (e) => UiKitVerticalChip(
                        caption: e.title ?? '',
                        sign: ImageWidget(link: e.iconPath ?? ''),
                        onTap: () => onUserTypeSelected?.call(e.type),
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
