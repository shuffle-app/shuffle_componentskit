import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CompanyHomeScreenComponent extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final List<String>? interests;
  final List<UiPlaceModel> places;
  final UiKitTag? tag;
  final VoidCallback? onCreatePlace;
  final ValueChanged<int>? onPlaceTapped;
  final List<UiKitStats>? profileStats;
  final Future<String?> Function(String?)? onCityChanged;
  final bool showSelectCity;
  final VoidCallback? onStripeTap;
  final StripeRegistrationStatus? stripeRegistrationStatus;

  const CompanyHomeScreenComponent({
    super.key,
    required this.name,
    required this.places,
    this.avatarUrl,
    this.interests,
    this.tag,
    this.onCreatePlace,
    this.onPlaceTapped,
    this.profileStats,
    this.onCityChanged,
    this.showSelectCity = false,
    this.onStripeTap,
    this.stripeRegistrationStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final textTheme = theme?.boldTextTheme;
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
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
              height: MediaQuery.viewPaddingOf(context).top,
            ),
            ProfileCard(
              name: name,
              avatarUrl: avatarUrl,
              tags: [
                if (tag != null) tag!,
              ],
              interests: interests,
              // badge: DynamicGradientPlate(
              //   content: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(
              //         S.of(context).Shuffle,
              //         style: textTheme?.caption1Bold.copyWith(color: Colors.black),
              //       ),
              //       const ImageWidget(
              //         iconData: ShuffleUiKitIcons.memeberGradientStar,
              //       ),
              //     ],
              //   ),
              // ),
              profileType: ProfileCardType.company,
              profileStats: profileStats,
              profileWidgets: stripeRegistrationStatus != null
                  ? [
                      UiKitStripeRegistrationTile(
                        status: stripeRegistrationStatus!,
                        onTap: onStripeTap,
                      )
                    ]
                  : null,
            ).paddingSymmetric(
              horizontal: horizontalMargin,
            ),
            SpacingFoundation.verticalSpace24,
            if (showSelectCity)
              SelectedCityRow(
                selectedCity: selectedCity,
                onTap: () async {
                  final city = await onCityChanged?.call(selectedCity.value) ?? S.current.SelectCity;
                  selectedCity.value = city == selectedCity.value ? S.current.SelectCity : city;
                },
              ).paddingOnly(bottom: SpacingFoundation.verticalSpacing24),
            Row(children: [
              Text(
                S.of(context).Places,
                style: textTheme?.title1,
                textAlign: TextAlign.left,
              ),
              horizontalMargin.widthBox,
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => showUiKitPopover(
                    context,
                    customMinHeight: 30.h,
                    showButton: false,
                    title: Text(
                      S.of(context).PlaceCompanyInfo,
                      style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.info,
                    width: 16.w,
                    color: theme?.colorScheme.darkNeutral900,
                  ),
                ),
              ),
            ]).paddingSymmetric(
              horizontal: horizontalMargin,
            ),
            SpacingFoundation.verticalSpace24,
            if (places.isEmpty)
              UiKitTitledActionCard(
                title: S.of(context).CreateYourPlaceAndInvitePeople,
                actionButton: context.gradientButton(
                  data: BaseUiKitButtonData(
                    text: S.of(context).CreatePlace.toUpperCase(),
                    onPressed: onCreatePlace,
                  ),
                ),
              ).paddingSymmetric(
                horizontal: horizontalMargin,
              ),
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = places.elementAt(index);

                return PlacePreview(
                  onTap: (id) => onPlaceTapped?.call(id),
                  place: item,
                  model: model,
                  status: item.moderationStatus,
                  updatedAt: item.updatedAt,
                );
              },
              separatorBuilder: (context, index) => SpacingFoundation.verticalSpace24,
              itemCount: places.length,
            ),
            if (places.isNotEmpty) ...[
              SpacingFoundation.verticalSpace24,
              context
                  .gradientButton(
                    data: BaseUiKitButtonData(
                        text: S.of(context).CreatePlace, onPressed: onCreatePlace, fit: ButtonFit.fitWidth),
                  )
                  .paddingSymmetric(
                    horizontal: horizontalMargin,
                  ),
            ],
            SpacingFoundation.verticalSpace24,
            kBottomNavigationBarHeight.heightBox
          ],
        ).paddingSymmetric(
          vertical: verticalMargin,
        ),
      ),
    );
  }
}

final ValueNotifier<String> selectedCity = ValueNotifier<String>(S.current.SelectCity);
