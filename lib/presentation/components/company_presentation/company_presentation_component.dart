import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../shuffle_components_kit.dart';

class CompanyPresentationComponent extends StatelessWidget {
  CompanyPresentationComponent({
    super.key,
    this.onNext,
  });

  final VoidCallback? onNext;

  final List<String> infoTexts = [
    S.current.CompanyPresentationSlider1,
    S.current.CompanyPresentationSlider2,
    S.current.CompanyPresentationSlider3,
    S.current.CompanyPresentationSlider4,
    S.current.CompanyPresentationSlider5,
    S.current.CompanyPresentationSlider6,
    S.current.CompanyPresentationSlider7,
    S.current.CompanyPresentationSlider8,
  ];

  final UiPlaceModel place = UiPlaceModel(
    id: 1,
    media: [
      UiKitMediaPhoto(link: GraphicsFoundation.instance.png.leto1.path),
      UiKitMediaPhoto(link: GraphicsFoundation.instance.png.leto4.path),
    ],
    title: 'L\'ETO The Wharf',
    logo: GraphicsFoundation.instance.png.lETOLogo.path,
    description:
        "Step right into the cozy wonderland of this cafe! It's the kind of place where the atmosphere wraps around you like a warm, fuzzy blanket, and the menu is as varied as a chameleon with a culinary streak. Brace yourself for a taste extravaganza that'll have your taste buds doing the conga!",
    baseTags: [
      UiKitTag(
        title: S.current.Restaurant,
        icon: ShuffleUiKitIcons.cup,
        unique: false,
      ),
      UiKitTag(
        title: 'Dh 170',
        icon: ShuffleUiKitIcons.label,
        unique: false,
      ),
      UiKitTag(
        title: S.current.Open,
        icon: ShuffleUiKitIcons.clock,
        unique: false,
      ),
      UiKitTag(
        title: '7 ${S.current.Min}',
        icon: ShuffleUiKitIcons.route,
        unique: false,
      ),
    ],
    tags: [
      UiKitTag(
        title: S.current.TastyCoffee,
        icon: GraphicsFoundation.instance.svg.coffee.path,
        unique: true,
      ),
      UiKitTag(
        title: S.current.CalmAtmosphere,
        icon: GraphicsFoundation.instance.svg.calm.path,
        unique: true,
      ),
      UiKitTag(
        title: S.current.TeaList,
        icon: GraphicsFoundation.instance.svg.teapot.path,
        unique: true,
      ),
    ],
    branches: ()async=>[
      /// mock branches
      HorizontalCaptionedImageData(
        imageUrl: GraphicsFoundation.instance.png.leto3.path,
        caption: 'L’ETO Marina Mall',
      ),
      HorizontalCaptionedImageData(
        imageUrl: GraphicsFoundation.instance.png.leto2.path,
        caption: 'L’ETO Dubai Hills Mall',
      ),
    ],
  );

  final List<String> avatars = [
    GraphicsFoundation.instance.png.avatars.avatar1.path,
    GraphicsFoundation.instance.png.avatars.avatar2.path,
    GraphicsFoundation.instance.png.avatars.avatar3.path,
    GraphicsFoundation.instance.png.avatars.avatar4.path,
    GraphicsFoundation.instance.png.avatars.avatar6.path,
    GraphicsFoundation.instance.png.avatars.avatar7.path,
    GraphicsFoundation.instance.png.avatars.avatar8.path,
  ];

  final List<String> placeImages = [
    GraphicsFoundation.instance.png.leto5.path,
    GraphicsFoundation.instance.png.leto7.path,
    GraphicsFoundation.instance.png.leto82.path,
    GraphicsFoundation.instance.png.leto4.path,
    GraphicsFoundation.instance.png.story.path,
  ];

  final List<String> names = [
    'John Doe',
    'Marry Jane',
    'Alex Doe',
    'Alice Mary',
    'Susan Alice',
    'William John',
    'Olga Nata',
    'Queen Elizabeth',
  ];

  final List<String> feedbackDescriptions = [
    'The food is great! There are plenty of waiters. The menu selection is great.It is comfortable to sit and watch the singing fountains. Not jostling on the seafront.',
    "Yes I have have many times faces bad experience in restaurant. One of this is two weeks ago I ordered chicken masala, biryani and roti. That's very bad. I never experienced such a food. That is terrific. And terrible food I have ever faced.",
    "I decided to try out the restaurant near the school where I work. It always smells good when I go to work. Once, I had lunch there, and I went for pizza cause it's my favorite dish. I had to wait more than 10 minutes to get my dish ready. The thing I don't like. But the pizza was very tasty, that leads me to think about coming back and try out other dishes. But it would be better if they serve people more faster.",
    "I decided to try out the restaurant near the school where I work. It always smells good when I go to work. Once, I had lunch there, and I went for pizza cause it's my favorite dish. I had to wait more than 10 minutes to get my dish ready. The thing I don't like. But the pizza was very tasty, that leads me to think about coming back and try out other dishes. But it would be better if they serve people more faster.",
  ];

  final List<DateTime> dateTimes = [
    DateTime.parse('2024-06-12T00:00:00.000Z'),
    DateTime.parse('2024-05-12T00:00:00.000Z'),
    DateTime.parse('2024-06-16T00:00:00.000Z'),
    DateTime.parse('2024-03-20T00:00:00.000Z'),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalConfiguration configuration = GlobalConfiguration(null, 'en');
    final AutoSizeGroup group = AutoSizeGroup();
    final List<FeedbackUiModel> feedbacks = List.generate(
      4,
      (index) {
        return FeedbackUiModel(
          id: index,
          feedbackAuthorName: names[index],
          feedbackAuthorPhoto: avatars[index],
          feedbackDateTime: dateTimes[index],
          feedbackRating: 5 - index,
          feedbackText: feedbackDescriptions[index],
        );
      },
    );
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = kIsWeb
        ? ComponentPlaceModel(
            version: '',
            pageBuilderType: PageBuilderType.page,
            positionModel: PositionModel(
              version: '',
              horizontalMargin: 16,
              verticalMargin: 10,
              bodyAlignment: Alignment.centerLeft,
            ),
          )
        : ComponentPlaceModel.fromJson(config['place']);
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        customTitle: Expanded(
          child: Text(
            S.current.PushUpYourBusiness,
            style: context.uiKitTheme?.boldTextTheme.title1,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        customToolbarBaseHeight: 0.14.sh,
        children: [
          SpacingFoundation.verticalSpace16,
          SizedBox(
            height: 0.17.sh,
            child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: EdgeInsetsFoundation.horizontal8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return UiKitCardWrapper(
                    gradient: theme?.themeMode == ThemeMode.light
                        ? GradientFoundation.lightShunyGreyGradient
                        : GradientFoundation.shunyGreyGradient,
                    child: SizedBox(
                      width: 1.sw - (2 * EdgeInsetsFoundation.horizontal16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfluencerAccountMark(),
                          SpacingFoundation.horizontalSpace4,
                          Expanded(
                            child: Text(
                              infoTexts[index],
                              style: regularTextTheme?.caption1,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ).paddingAll(EdgeInsetsFoundation.all16),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    SpacingFoundation.horizontalSpace8,
                itemCount: infoTexts.length),
          ),
          SpacingFoundation.verticalSpace16,
          TitleWithAvatar(
            title: place.title,
            avatarUrl: place.logo,
            horizontalMargin: horizontalMargin,
            trailing: GestureDetector(
              onTap: () {},
              child: Icon(
                ShuffleUiKitIcons.share,
                color: colorScheme?.darkNeutral800,
              ),
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitMediaSliderWithTags(
            media: place.media,
            description: place.description,
            baseTags: place.baseTags,
            initialDescriptionHide: false,
            uniqueTags: place.tags,
            horizontalMargin: horizontalMargin,
            actions: [
              UiKitCardWrapper(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Ink(
                      child: Icon(ShuffleUiKitIcons.alertcircle,
                              color: colorScheme?.darkNeutral800, size: 16.sp)
                          .paddingAll(EdgeInsetsFoundation.all6),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              UiKitUsersRespectCard(
                users: List<RespectFromUser>.generate(
                  avatars.length,
                  (index) => RespectFromUser(
                    name: 'Alice',
                    avatarUrl:
                        avatars[index],
                  ),
                ),
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal32),
            ],
            branches: place.branches,
          ),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.zero,
            padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
            child: UiKitVideoInterviewTile(
              onPlayTap: () {},
              imagePath:  GraphicsFoundation.instance.png.leto7.path,
              userNickname: 'msgeidt',
              title: S.current.GreatInterviewWithOwner,
              userImage: avatars[3],
              userName: 'Aspen Geidt',
            ),
          ),
          SpacingFoundation.verticalSpace16,
          Row(
            children: [
              Expanded(
                child: UpcomingEventPlaceActionCard(
                  value: 'in 2 days',
                  group: group,
                  rasterIconAsset: GraphicsFoundation.instance.png.events,
                  action: () {},
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              Expanded(
                child: PointBalancePlaceActionCard(
                  value: '2650',
                  group: group,
                  rasterIconAsset: GraphicsFoundation.instance.png.money,
                  action: () {},
                  buttonTitle: S.current.SpendIt,
                ),
              ),
            ],
          ).paddingSymmetric(
              horizontal: horizontalMargin,
              vertical: EdgeInsetsFoundation.vertical24),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.ReactionsBy,
                      style: regularTextTheme?.body,
                    ),
                    const MemberPlate(),
                  ],
                ).paddingSymmetric(
                    horizontal: EdgeInsetsFoundation.horizontal16),
                SpacingFoundation.verticalSpace16,
                SizedBox(
                  height: .25.sh,
                  width: 1.sw,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: EdgeInsetsFoundation.horizontal12),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(placeImages.length, (index) {
                      return UiKitReactionPreview(
                        imagePath: placeImages[index],
                        customWidth: 0.27.sw,
                      ).paddingSymmetric(
                          horizontal: EdgeInsetsFoundation.horizontal4);
                    }),
                  ),
                )
              ],
            ).paddingSymmetric(vertical: EdgeInsetsFoundation.all16),
          ),
          SpacingFoundation.verticalSpace24,
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.ReviewsByCritics,
                  style: regularTextTheme?.body,
                ).paddingAll(EdgeInsetsFoundation.all16),
                SizedBox(
                  height: 0.25.sh,
                  width: 1.sw,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          horizontal: EdgeInsetsFoundation.horizontal16),
                      itemBuilder: (context, index) {
                        if (index == feedbacks.length - 1) {
                          return UiKitCardWrapper(
                            color: theme?.colorScheme.surface3,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Ink(
                                  child: Row(
                                    children: [
                                      Text(
                                        S.current.ShowMore,
                                        style: boldTextTheme?.caption1Bold,
                                      ),
                                      SpacingFoundation.horizontalSpace8,
                                      Icon(
                                        ShuffleUiKitIcons.chevronright,
                                        size: 24.sp,
                                        color:
                                            theme?.themeMode == ThemeMode.dark
                                                ? ColorsFoundation.lightSurface
                                                : ColorsFoundation.surface,
                                      )
                                    ],
                                  ).paddingSymmetric(
                                      horizontal:
                                          EdgeInsetsFoundation.horizontal12),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            width:
                                1.sw - (2 * EdgeInsetsFoundation.horizontal16),
                            child: UiKitFeedbackCard(
                              rating: feedbacks[index].feedbackRating,
                              title: feedbacks[index].feedbackAuthorName,
                              maxLines:3,
                              text: feedbacks[index].feedbackText,
                              datePosted: feedbacks[index].feedbackDateTime,
                              avatarUrl: feedbacks[index].feedbackAuthorPhoto,
                              helpfulCount: feedbacks[index].helpfulCount,
                              onLike: () {},
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) =>
                          SpacingFoundation.horizontalSpace16,
                      itemCount: feedbacks.length),
                ),
              ],
            ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MemberPlate(),
              Text(
                S.current.AboutUs,
                style: boldTextTheme?.subHeadline,
              )
            ],
          ).paddingAll(EdgeInsetsFoundation.all16),
          UiKitVoiceListenCard(
            userName: names[2],
            userImage: avatars[2],
            userNickname: 'alex_doe',
            duration: const Duration(seconds: 70),
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          SpacingFoundation.verticalSpace24,
          UiKitDescriptionGrid(
            spacing: SpacingFoundation.horizontalSpacing16,
            children: [
              DescriptionGridData(
                title: S.current.Address,
                value:
                    'Bluewaters, The Wharf - Dubai Bluewaters Island, The Wharf - Blue Waters Island - level G street 15a - Dubai - ОАЭ',
              ),
              DescriptionGridData(
                title: S.current.OpenNow,
                value: '8:30 - 22:00',
              ),
              DescriptionGridData(
                title: S.current.Website,
                value: 'letocaffe.com',
              ),
              DescriptionGridData(
                title: S.current.Phone,
                value: '+97142715710',
              ),
            ],
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          BottomBookingBar(
            onBook: () {},
            model: ComponentPlaceModel.fromJson(
                        configuration.appConfig.content['place'])
                    .bookingElementModel ??
                BookingElementModel(version: '0'),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusFoundation.all24,
                child: ImageWidget(
                  link: GraphicsFoundation.instance.png.entertainment.path,
                  height: 0.25.sh,
                  width: 1.sw-(2*EdgeInsetsFoundation.horizontal20),
                  fit: BoxFit.fitHeight,
                ),
              ),
              UiKitBlurWrapper(
                borderRadius: BorderRadiusFoundation.all24,
                border: Border.all(width: 0),
                childHorizontalPadding: EdgeInsetsFoundation.horizontal16,
                childVerticalPadding: EdgeInsetsFoundation.vertical16,
                child: Text(
                  S.current.GoAheadAndGrowYourBusiness,
                  style: boldTextTheme?.title1,
                ),
              ).paddingAll(EdgeInsetsFoundation.all4)
            ],
          ).paddingAll(EdgeInsetsFoundation.all16),
          context
              .button(
                data: BaseUiKitButtonData(
                    text: S.current.Next, onPressed: onNext),
              )
              .paddingSymmetric(
                  horizontal: EdgeInsetsFoundation.horizontal16,
                  vertical: EdgeInsetsFoundation.vertical8),
        ],
      ),
    );
  }
}
