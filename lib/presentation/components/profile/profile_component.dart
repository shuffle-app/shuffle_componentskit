import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_profile_model.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

//ignore_for_file: no-empty-block

class ProfileComponent extends StatelessWidget {
  final UiProfileModel profile;
  final VoidCallback? onHowItWorksPoped;
  final ValueChanged<InvitationData?>? onInvite;
  final bool showHowItWorks;
  final List<HangoutRecommendation>? recommendedUsers;
  final List<UiEventModel>? events;
  final Function(UiEventModel)? onEventTap;
  final VoidCallback? onFulfillDream;

  const ProfileComponent({
    Key? key,
    required this.profile,
    this.recommendedUsers,
    this.showHowItWorks = false,
    this.onHowItWorksPoped,
    this.onFulfillDream,
    this.onInvite,
    this.events,
    this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final titleAlignment = model.positionModel?.titleAlignment;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: titleAlignment.mainAxisAlignment,
          crossAxisAlignment: titleAlignment.crossAxisAlignment,
          children: [profile.cardWidget]).paddingSymmetric(horizontal: horizontalMargin),
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: bodyAlignment.mainAxisAlignment,
        crossAxisAlignment: bodyAlignment.crossAxisAlignment,
        children: [
          // SpacingFoundation.verticalSpace24,
          // ProfileAttitudeTabs(
          //   onTappedTab: (index) {},
          //   tabs: const [
          //     ProfileAttitudeTab(title: 'LOVED'),
          //     ProfileAttitudeTab(title: 'HATED'),
          //   ],
          // ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          SpacingFoundation.verticalSpace24,
          Stack(
            children: [
              Text(
                S.of(context).FindSomeoneToHangOutWith,
                style: textTheme?.title1,
              ),
              if (showHowItWorks)
                HowItWorksWidget(
                  element: model.content.body![ContentItemType.hintDialog]!,
                  onPop: onHowItWorksPoped,
                  customOffset: Offset(MediaQuery.sizeOf(context).width / 1.5, 35),
                ),
            ],
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          SpacingFoundation.verticalSpace24,
          UiKitHorizontalScroll3D(
            itemBuilder: (BuildContext context, int index) {
              final user = recommendedUsers?[index];

              return UiKitFindSomeoneCard(
                avatarUrl: user?.userAvatar ?? GraphicsFoundation.instance.png.mockUserAvatar.path,
                userNickName: user?.userNickname ?? '',
                userName: user?.userName ?? '',
                userPoints: user?.userPointsBalance ?? 0,
                sameInterests: user?.commonInterests ?? 0,
                onMessage: () {
                  buildComponent(
                    context,
                    ComponentModel.fromJson(GlobalConfiguration().appConfig.content['invite_people_places']),
                    ComponentBuilder(
                      useRootNavigator: true,
                      child: Builder(
                        builder: (context) {
                          var model = UiInviteToFavouritePlacesModel(
                            date: DateTime.now(),
                          );
                          String? selected;

                          return StatefulBuilder(
                            builder: (context, state) => InviteToFavouritePlacesComponent(
                              places: List<UiKitLeadingRadioTile>.generate(
                                10,
                                (index) => UiKitLeadingRadioTile(
                                  title: S.of(context).NPlace(index),
                                  selected: selected == S.of(context).NPlace(index),
                                  onTap: () {
                                    state(() {
                                      selected = S.of(context).NPlace(index);
                                      // if (!selected.remove('$index place')) {
                                      //   selected.add('$index place');
                                      // }
                                    });
                                  },
                                  avatarLink: GraphicsFoundation.instance.png.inviteMock1.path,
                                  tags: [
                                    UiKitTag(title: S.of(context).Title, icon: ShuffleUiKitIcons.cocktail),
                                    UiKitTag(title: S.of(context).Title, icon: ShuffleUiKitIcons.cocktail),
                                    UiKitTag(title: S.of(context).Title, icon: ShuffleUiKitIcons.cocktail),
                                    UiKitTag(title: S.of(context).Title, icon: ShuffleUiKitIcons.cocktail),
                                  ],
                                ),
                              ),
                              uiModel: model,
                              onInvite: onInvite == null || selected == null
                                  ? null
                                  : () {
                                      Navigator.of(context, rootNavigator: true).pop();

                                      onInvite?.call(
                                        InvitationData(
                                          user: user,
                                          placeId: 0,
                                          placePhotoUrl: GraphicsFoundation.instance.png.place.path,
                                          placeName: selected ?? '',
                                          placeTags: [
                                            UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                                            UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                                            UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                                            UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                                          ],
                                        ),
                                      );
                                    },
                              onDatePressed: () async {
                                final newDate = await showUiKitCalendarDialog(
                                  context,
                                  selectableDayPredicate: (day) {
                                    log(day.toIso8601String(), name: 'ProfileComponent');

                                    return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
                                  },
                                );
                                if (newDate != null) {
                                  state(
                                    () {
                                      model = UiInviteToFavouritePlacesModel(
                                        date: newDate,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: recommendedUsers?.length ?? 3,
          ),
          SpacingFoundation.verticalSpace24,
          if (events != null) MyEventsComponent(title: S.of(context).MyEvents, onTap: onEventTap ?? (_) {}, events: events!),
          SpacingFoundation.verticalSpace24,
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
                  Text(
                    S.of(context).AskOrSupport,
                    style: textTheme?.title1,
                  ),

              if (showHowItWorks)
                HowItWorksWidget(
                  element: model.content.subtitle![ContentItemType.hintDialog]!,
                  onPop: onHowItWorksPoped,
                  customOffset: Offset(MediaQuery.sizeOf(context).width / 1.4, 8),
                ),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace16,
          Text(
            S.of(context).AcceptDonations,
            style: context.uiKitTheme?.boldTextTheme.caption1Medium,
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace16,
          GradientableWidget(
              gradient: GradientFoundation.attentionCard,
              child: context.outlinedButton(
                data: BaseUiKitButtonData(
                  fit: ButtonFit.fitWidth,
                  text: S.of(context).FulfillTheDream.toUpperCase(),
                  onPressed: () => onFulfillDream?.call(),
                ),
              )).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace24,
          kBottomNavigationBarHeight.heightBox,
          // const UnderDevelopment(),
          // ProfileStoriesList(
          //   stories: List.generate(
          //     5,
          //     (index) => const ProfileStory(
          //       image: 'assets/images/png/profile_story_1.png',
          //     ),
          //   ),
          // ),
          // SpacingFoundation.verticalSpace24,
        ],
      )
    ]).paddingSymmetric(vertical: (model.positionModel?.verticalMargin ?? 0).toDouble());
  }
}
