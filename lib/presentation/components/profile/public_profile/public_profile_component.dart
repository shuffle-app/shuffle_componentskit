import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../../domain/config_models/profile/component_profile_model.dart';

class PublicProfileComponent extends StatelessWidget {
  final UiProfileModel uiProfileModel;
  final ProfileStats? profileStats;

  const PublicProfileComponent({super.key, required this.uiProfileModel, this.profileStats});

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return BlurredAppBarPage(
        centerTitle: true,
        title: uiProfileModel.name ?? '',
        autoImplyLeading: true,
        bodyBottomSpace: verticalMargin,
        children: [
          verticalMargin.heightBox,
          uiProfileModel.cardWidget.paddingSymmetric(horizontal: horizontalMargin),
          if (profileStats != null)
            ProfileHighlights(
              placesVisited: profileStats!.placesVisited,
              reviewsPosted: profileStats!.reviewsPosted,
              points: profileStats!.points,
            ).paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing16),
        ]);
  }
}
