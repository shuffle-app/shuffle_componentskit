import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/refresher_component/ui_model/refresher_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class RefresherItem extends StatelessWidget {
  final RefresherUiModel? item;
  final VoidCallback? onEdit;
  final VoidCallback? onDismissed;
  final VoidCallback? onLongPress;
  final bool isEditingMode;

  const RefresherItem({
    super.key,
    this.item,
    this.onEdit,
    this.onDismissed,
    this.isEditingMode = false,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Dismissible(
        key: ValueKey(item?.id),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {DismissDirection.endToStart: 0.6},
        background: UiKitBackgroundDismissible(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return false;
          } else if (direction == DismissDirection.endToStart) {
            return true;
          }
          return false;
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            onDismissed?.call();
          }
        },
        child: UiKitCardWrapper(
          color: colorScheme?.surface2,
          borderRadius: BorderRadiusFoundation.all24r,
          child: Stack(
            children: [
              Row(
                children: [
                  context.userAvatar(
                    size: UserAvatarSize.x40x40,
                    type: UserTileType.ordinary,
                    imageUrl: item?.contentImage ?? GraphicsFoundation.instance.png.mockAvatar.path,
                    userName: '',
                  ),
                  SpacingFoundation.horizontalSpace8,
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item?.contentTitle ?? '',
                          style: theme?.boldTextTheme.caption1Bold,
                        ),
                        SpacingFoundation.verticalSpace4,
                        Row(
                          children: [
                            ImageWidget(
                              height: 10.h,
                              fit: BoxFit.fill,
                              color: ColorsFoundation.mutedText,
                              iconData: item?.isLaunched ?? true
                                  ? ShuffleUiKitIcons.playoutline
                                  : ShuffleUiKitIcons.stopoutline,
                            ),
                            SpacingFoundation.horizontalSpace2,
                            Expanded(
                              child: Text(
                                item?.isLaunched ?? true ? S.of(context).Launched : S.of(context).Expired,
                                style:
                                    theme?.regularTextTheme.caption4Regular.copyWith(color: ColorsFoundation.mutedText),
                              ),
                            ),
                            SpacingFoundation.horizontalSpace2,
                            Text(
                              formatDateWithCustomPattern(
                                'dd.MM.yyyy',
                                (item?.isLaunchedDate ?? DateTime.now()).toLocal(),
                              ),
                              style:
                                  theme?.regularTextTheme.caption4Regular.copyWith(color: ColorsFoundation.mutedText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ).paddingAll(EdgeInsetsFoundation.all12),
              if (isEditingMode)
                Positioned.fill(
                  child: ColoredBox(
                    color: ColorsFoundation.neutral48,
                    child: Center(
                      child: context
                          .button(
                            data: BaseUiKitButtonData(
                              borderColor: colorScheme?.headingTypography,
                              onPressed: onEdit,
                              backgroundColor: colorScheme?.surface3,
                              iconInfo: BaseUiKitButtonIconData(
                                iconPath: GraphicsFoundation.instance.svg.pencil.path,
                                color: colorScheme?.headingTypography,
                              ),
                            ),
                          )
                          .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
