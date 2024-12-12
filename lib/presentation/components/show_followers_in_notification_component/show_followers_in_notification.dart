import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/uiowner_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

void showFollowersInNotification(
  BuildContext context, {
  List<UiOwnerModel>? followers,
  ValueChanged<int>? onFollow,
  ValueChanged<int>? onMessageTap,
  ValueChanged<int>? onBlockTap,
}) {
  showUiKitGeneralFullScreenDialog(
    context,
    GeneralDialogData(
      child: SizedBox(
        height: 0.8.sh,
        child: ListView(
          children: followers
                  ?.map((e) => GestureDetector(
                      onTap: e.onTap,
                      child: e
                          .buildMenuItem(
                            onMessageTap: (index) {},
                            onFollowTap: [UserTileType.pro, UserTileType.influencer].contains(e.type) ? onFollow : null,
                            onBlockTap: onBlockTap,
                          )
                          .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12)))
                  .toList() ??
              [
                Center(
                  child: Text(
                    S.of(context).NothingFound.toUpperCase(),
                    style: context.uiKitTheme?.boldTextTheme.caption1Bold,
                  ),
                ),
              ],
        ).paddingSymmetric(
          horizontal: SpacingFoundation.horizontalSpacing16,
          vertical: SpacingFoundation.verticalSpacing12,
        ),
      ),
    ),
  );
}
