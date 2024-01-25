import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchSocialComponent extends StatelessWidget {
  final VoidCallback? onFilterPressed;
  final ValueChanged<String>? onContentTypePressed;
  final List<SearchSocialCardUiModel>? placesEvents;
  final List<SearchSocialCardUiModel>? servicesEvents;

  const SearchSocialComponent({
    Key? key,
    this.onFilterPressed,
    this.onContentTypePressed,
    this.placesEvents,
    this.servicesEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;
    final isLightTheme = context.uiKitTheme?.themeMode == ThemeMode.light;
    final model = ComponentModel.fromJson(GlobalConfiguration().appConfig.content['search_social_page']);
    final placeTypes = model.content.body?[ContentItemType.horizontalList]?.properties?.entries
            .where((element) => element.value.type == 'place')
            .toList() ??
        [];
    placeTypes.sort((a, b) => a.value.sortNumber!.compareTo(b.value.sortNumber!));
    final servicesTypes = model.content.body?[ContentItemType.horizontalList]?.properties?.entries
            .where((element) => element.value.type == 'services')
            .toList() ??
        [];
    servicesTypes.sort((a, b) => a.value.sortNumber!.compareTo(b.value.sortNumber!));
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return BlurredAppBarPage(
      centerTitle: true,
      autoImplyLeading: true,
      title: 'Social',
      children: [
        SpacingFoundation.verticalSpace16,
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Filter',
              style: textTheme?.labelLarge,
            ),
            SpacingFoundation.horizontalSpace12,
            context.outlinedBadgeButton(
              badgeAlignment: Alignment.topRight,
              data: BaseUiKitButtonData(
                onPressed: onFilterPressed,
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.filter,
                  color: colorScheme?.inverseSurface,
                ),
              ),
            ),
            SpacingFoundation.horizontalSpace16,
          ],
        ),
        SpacingFoundation.verticalSpace16,
        UiKitTitledSection(
          borderRadius: BorderRadius.zero,
          title: S.of(context).Places,
          titleStyle: textTheme?.title1,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SpacingFoundation.horizontalSpace16,
                ...placeTypes
                    .map<Widget>(
                      (e) => UiKitSocialSearchContentTypeCard.places(
                        onTap: () => onContentTypePressed?.call(e.key),
                        title: e.key,
                        iconData: BaseUiKitButtonIconData(iconPath: e.value.imageLink),
                        iconRingColor: e.value.color,
                        backgroundColor: isLightTheme ? colorScheme?.surface : null,
                      ).paddingOnly(right: SpacingFoundation.horizontalSpacing16),
                    )
                    .toList(),
              ],
            ),
          ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16),
        ),
        SpacingFoundation.verticalSpace24,
        if (placesEvents != null && placesEvents!.isNotEmpty) ...[
          UiKitExpandableList(
            itemsTitle: S.of(context).Places,
            items: placesEvents!
                .map(
                  (e) => UiKitSocialSearchCard(
                    onTap: e.onTap,
                    title: e.title,
                    subtitle: e.subtitle,
                    distance: e.distance,
                    imageData: e.imageData,
                    progress: e.progress,
                    leadingImageBorderRadius: e.leadingImageBorderRadius,
                  ),
                )
                .toList(),
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace24,
        ],
        UiKitCardWrapper(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top useful places rated by',
                    style: textTheme?.body,
                  ),
                  SpacingFoundation.verticalSpace4,
                  const MemberPlate(),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ImageWidget(
                  svgAsset: GraphicsFoundation.instance.svg.indexFingerHands,
                  height: 0.15625.sw,
                  width: 0.15625.sw,
                  fit: BoxFit.cover,
                ).paddingOnly(top: EdgeInsetsFoundation.vertical12, right: EdgeInsetsFoundation.horizontal6),
              ),
            ],
          ).paddingOnly(
            top: EdgeInsetsFoundation.vertical16,
            left: EdgeInsetsFoundation.horizontal16,
            right: EdgeInsetsFoundation.zero,
            bottom: EdgeInsetsFoundation.vertical16,
          ),
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace24,
        UiKitTitledSection(
          borderRadius: BorderRadius.zero,
          title: S.of(context).Services,
          titleStyle: textTheme?.title1,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SpacingFoundation.horizontalSpace16,
                ...servicesTypes.map<Widget>(
                  (e) {
                    final isFirst = e == servicesTypes.first;
                    if (isFirst) {
                      return UiKitSocialSearchContentTypeCard.services(
                        onTap: () => onContentTypePressed?.call(e.key),
                        title: e.key,
                        customCardWidth: 0.4473.sw,
                        iconData: BaseUiKitButtonIconData(iconPath: e.value.imageLink),
                        iconRingColor: e.value.color,
                      ).paddingOnly(right: SpacingFoundation.horizontalSpacing16);
                    }

                    return UiKitSocialSearchContentTypeCard.services(
                      onTap: () => onContentTypePressed?.call(e.key),
                      title: e.key,
                      iconData: BaseUiKitButtonIconData(iconPath: e.value.imageLink),
                      iconRingColor: e.value.color,
                    ).paddingOnly(right: SpacingFoundation.horizontalSpacing16);
                  },
                ).toList(),
              ],
            ),
          ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16),
        ),
        SpacingFoundation.verticalSpace24,
        if (servicesEvents != null && servicesEvents!.isNotEmpty) ...[
          UiKitExpandableList(
            itemsTitle: S.of(context).Services,
            items: servicesEvents!
                .map(
                  (e) => UiKitSocialSearchCard(
                    onTap: e.onTap,
                    title: e.title,
                    subtitle: e.subtitle,
                    distance: e.distance,
                    imageData: e.imageData,
                    progress: e.progress,
                    leadingImageBorderRadius: e.leadingImageBorderRadius,
                  ),
                )
                .toList(),
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace24,
        ],
        SpacingFoundation.bottomNavigationBarSpacing,
      ],
    );
  }
}
