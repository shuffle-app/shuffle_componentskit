import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_profile_model.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ProfileComponent extends StatelessWidget {
  final UiProfileModel profile;
  final VoidCallback? onHowItWorksPoped;
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
    this.events,
    this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
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
                'Find someone to hang out with',
                style: textTheme?.title1,
              ),
              if (showHowItWorks)
                HowItWorksWidget(
                    element: model.content.body![ContentItemType.hintDialog]!,
                    onPop: onHowItWorksPoped,
                    customOffset: Offset(MediaQuery.sizeOf(context).width / 1.5, 35)),
            ],
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          SpacingFoundation.verticalSpace24,
          UiKitHorizontalScroll3D(
            itemBuilder: (BuildContext context, int index) => UiKitFindSomeoneCard(
                avatarUrl: recommendedUsers?[index].userAvatar ?? GraphicsFoundation.instance.png.mockUserAvatar.path,
                userNickName: recommendedUsers?[index].userNickname ?? '',
                userName: recommendedUsers?[index].userName ?? '',
                userPoints: recommendedUsers?[index].userPointsBalance ?? 0,
                sameInterests: recommendedUsers?[index].commonInterests ?? 0,
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
                          List<String> selected = [];

                          return StatefulBuilder(
                            builder: (context, state) => InviteToFavouritePlacesComponent(
                              places: List<UiKitLeadingRadioTile>.generate(
                                10,
                                (index) => UiKitLeadingRadioTile(
                                  title: '$index place',
                                  selected: selected.contains('$index place'),
                                  onTap: () {
                                    state(() {
                                      if (!selected.remove('$index place')) {
                                        selected.add('$index place');
                                      }
                                    });
                                  },
                                  avatarLink: GraphicsFoundation.instance.png.inviteMock1.path,
                                  tags: [
                                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                                    UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                                  ],
                                ),
                              ),
                              uiModel: model,
                              onInvite: () {},
                              onDatePressed: () async {
                                final newDate = await showUiKitCalendarDialog(context);
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
                }),
            itemCount: recommendedUsers?.length ?? 3,
          ),
          SpacingFoundation.verticalSpace24,
          if (events != null) MyEventsComponent(title: 'My Events', onTap: onEventTap ?? (_) {}, events: events!),
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Ask or support',
                style: textTheme?.title1,
                textAlign: TextAlign.left,
              ),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace16,
          context
              .gradientButton(
                data: BaseUiKitButtonData(
                  fit: ButtonFit.fitWidth,
                  text: 'fulfill the dream'.toUpperCase(),
                  onPressed: () => onFulfillDream?.call(),
                ),
              )
              .paddingSymmetric(horizontal: horizontalMargin),
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
