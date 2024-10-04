import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ActivationOffersComponent extends StatelessWidget {
  final UniversalNotOfferRemUiModel? offerUiModel;
  final List<UiProfileModel>? users;
  final ValueChanged<UiProfileModel>? onDetailsTap;

  const ActivationOffersComponent({
    super.key,
    this.offerUiModel,
    this.users,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Offer,
        centerTitle: true,
        autoImplyLeading: true,
        childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        children: [
          SpacingFoundation.verticalSpace16,
          OfferTitleWidget(offerUiModel: offerUiModel),
          SpacingFoundation.verticalSpace16,
          context.gradientButton(
            data: BaseUiKitButtonData(
              text: 'Code scanner'.toUpperCase(),
              onPressed: () {},
            ),
          ),
          SpacingFoundation.verticalSpace16,
          if (users != null && users!.isNotEmpty)
            ...users!.map((user) => UserInOfferWidget(
                  user: user,
                  onDetailsTap: onDetailsTap,
                ).paddingOnly(bottom: SpacingFoundation.verticalSpacing20))
          else
            Text(
              S.of(context).NothingFound,
              style: boldTextTheme?.caption1Medium,
            ),
        ],
      ),
    );
  }
}

class OfferTitleWidget extends StatelessWidget {
  final UniversalNotOfferRemUiModel? offerUiModel;

  const OfferTitleWidget({
    super.key,
    this.offerUiModel,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offerUiModel?.title ?? S.of(context).NothingFound,
          style: boldTextTheme?.title2,
        ),
        SpacingFoundation.verticalSpace2,
        Row(
          children: [
            Text(
              '${offerUiModel?.pointPrice ?? 0} ${S.of(context).PointsCount(offerUiModel?.pointPrice ?? 0).capitalize()}',
              style: boldTextTheme?.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
            ),
            const Spacer(),
            Text(
              '${formatDateWithCustomPattern(
                'dd.MM',
                (offerUiModel?.selectedDates?.first ?? DateTime.now()).toLocal(),
              )} - ${formatDateWithCustomPattern(
                'dd.MM.yyyy',
                (offerUiModel?.selectedDates?.last ?? DateTime.now()).toLocal(),
              )}',
              style: boldTextTheme?.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
            ),
          ],
        ),
      ],
    );
  }
}

class UserInOfferWidget extends StatelessWidget {
  final UiProfileModel? user;
  final ValueChanged<UiProfileModel>? onDetailsTap;

  const UserInOfferWidget({
    super.key,
    this.user,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    return Row(
      children: [
        context.userAvatar(
          size: UserAvatarSize.x40x40,
          type: UserTileType.ordinary,
          userName: '',
          imageUrl: user?.avatarUrl,
        ),
        SpacingFoundation.horizontalSpace16,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name ?? S.of(context).NothingFound,
              style: boldTextTheme?.caption1Medium,
            ),
            Text(
              user?.nickname ?? S.of(context).NothingFound,
              style: boldTextTheme?.caption1Bold.copyWith(color: ColorsFoundation.mutedText),
            ),
          ],
        ),
        const Spacer(),
        if (onDetailsTap != null)
          PopupMenuButton(
            icon: const ImageWidget(iconData: ShuffleUiKitIcons.morevert),
            splashRadius: 1,
            menuPadding: EdgeInsets.all(EdgeInsetsFoundation.all24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusFoundation.all16,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: user,
                child: Text(
                  'Details',
                  style: boldTextTheme?.caption2Medium.copyWith(color: Colors.black),
                ),
              ),
            ],
            onSelected: onDetailsTap,
          )
      ],
    );
  }
}
