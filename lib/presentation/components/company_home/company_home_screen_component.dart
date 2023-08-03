import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyHomeScreenComponent extends StatelessWidget {
  final String name;
  final List<String>? interests;
  final List<UiPlaceModel> places;
  final VoidCallback? onCreatePlace;
  final ValueChanged<int>? onPlaceTapped;
  final List<UiKitStats>? profileStats;

  const CompanyHomeScreenComponent({
    super.key,
    required this.name,
    required this.places,
    this.interests,
    this.onCreatePlace,
    this.onPlaceTapped,
    this.profileStats,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentModel model = ComponentModel.fromJson(config['company_home']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: bodyAlignment.crossAxisAlignment,
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            ProfileCard(
              name: name,
              tags: [
                UiKitTag(
                  title: 'Restaurant',
                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                ),
                UiKitTag(
                  title: 'Restaurant',
                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                ),
              ],
              interests: [
                'Tourists',
                'Luxury',
              ],
              badge: DynamicGradientPlate(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'shuffle',
                      style: textTheme?.caption1Bold.copyWith(color: Colors.black),
                    ),
                    ImageWidget(
                      svgAsset: GraphicsFoundation.instance.svg.memeberGradientStar,
                    ),
                  ],
                ),
              ),
              profileType: ProfileCardType.company,
              avatarUrl: GraphicsFoundation.instance.png.mockAvatar.path,
              profileStats: profileStats,
            ),
            SpacingFoundation.verticalSpace24,
            Text(
              'Places',
              style: textTheme?.title1,
              textAlign: TextAlign.left,
            ),
            SpacingFoundation.verticalSpace24,
            if (places.isEmpty)
              UiKitTitledActionCard(
                title: 'Create your place and invite people',
                actionButton: context.gradientButton(
                  data: BaseUiKitButtonData(
                    text: 'Create place'.toUpperCase(),
                    onPressed: onCreatePlace,
                  ),
                ),
              ),
            if (places.isNotEmpty)
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = places.elementAt(index);

                  return PlacePreview(
                    onTap: (id) => onPlaceTapped?.call(id),
                    place: UiPlaceModel(
                      id: item.id,
                      title: item.title,
                      description: item.description,
                      media: item.media,
                      tags: item.tags,
                      baseTags: item.baseTags,
                    ),
                    model: model,
                  );
                },
                separatorBuilder: (context, index) => SpacingFoundation.verticalSpace24,
                itemCount: places.length,
              ),
            if (places.isNotEmpty) ...[
              SpacingFoundation.verticalSpace24,
              context.gradientButton(
                data: BaseUiKitButtonData(
                  text: 'Create place',
                  onPressed: onCreatePlace,
                ),
              ),
            ],
            SpacingFoundation.verticalSpace24,
          ],
        ).paddingSymmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
      ),
    );
  }
}
