import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../shuffle_components_kit.dart';

class SearchSocialSectionItemDetailsComponent extends StatelessWidget {
  final SearchSocialSectionItemUiModel model;
  final ComplaintFormComponent? complaintFormComponent;

  const SearchSocialSectionItemDetailsComponent({
    Key? key,
    required this.model,
    this.complaintFormComponent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalConfiguration().appConfig.content['search_social_section_item_details'];
    final componentModel = ComponentModel.fromJson(config);
    final horizontalMargin = (componentModel.positionModel?.horizontalMargin ?? 0).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleWithAvatar(
          title: model.headerTitle,
          avatarUrl: model.headerAvatarLink,
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace16,
        UiKitMediaSliderWithTags(
          rating: model.rating,
          media: model.sliderMedia,
          description: model.description,
          baseTags: model.baseTags,
          uniqueTags: model.uniqueTags,
          horizontalMargin: horizontalMargin,
          actions: [
            if (complaintFormComponent != null)
              context.smallOutlinedButton(
                blurred: true,
                data: BaseUiKitButtonData(
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.alertcircle,
                    color: context.uiKitTheme?.colorScheme.darkNeutral800,
                  ),
                  onPressed: () {
                    showUiKitGeneralFullScreenDialog(
                      context,
                      GeneralDialogData(
                        topPadding: 0.3.sh,
                        useRootNavigator: false,
                        child: complaintFormComponent!,
                      ),
                    );
                  },
                ),
                color: Colors.white.withOpacity(0.01),
                blurValue: 25,
              ),
          ],
        ),
        if (model.descriptionItems != null) ...[
          SpacingFoundation.verticalSpace24,
          Wrap(
            spacing: SpacingFoundation.horizontalSpacing16,
            runSpacing: SpacingFoundation.verticalSpacing20,
            children: model.descriptionItems!
                .map((e) => GestureDetector(
                    onTap: () {
                      final url = e.descriptionUrl ?? e.description;

                      if (url.startsWith('http')) {
                        launchUrlString(url);
                      } else if (url.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                        log('launching $url', name: 'PlaceComponent');
                        launchUrlString('tel:${url}');
                      }
                    },
                    child: UiKitTitledDescriptionGridWidget(
                      title: e.title,
                      description: e.description,
                      spacing: horizontalMargin * 0.75,
                    )))
                .toList(),
          ).paddingSymmetric(horizontal: horizontalMargin),
        ],
        SpacingFoundation.bottomNavigationBarSpacing,
      ],
    );
  }
}
