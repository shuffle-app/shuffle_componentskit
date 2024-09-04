import 'dart:io';
import 'dart:ui';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  HttpOverrides.global = MyHttpOverrides();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalConfiguration configuration = GlobalConfiguration(null, 'en');
  ThemeData? _theme;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(320, 480),
      minTextAdapt: true,
      builder: (context, child) {
        return UiKitTheme(
            onThemeUpdated: (theme) => setState(() => _theme = theme),
            onLocaleUpdated: (locale) => setState(() => _locale = locale),
            child: WidgetsFactory(
                child: MaterialApp(
              locale: _locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              title: 'Shuffle Demo',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: _theme ?? UiKitThemeFoundation.defaultTheme,
              // theme: UiKitThemeFoundation.lightTheme,
              //TODO: think about it
              home: configuration.isLoaded
                  ? GlobalComponent(globalConfiguration: configuration, child: const ComponentsTestPage())
                  : Builder(builder: (c) {
                      configuration
                          .load(version: '1.0.18')
                          .then((_) => Future.delayed(const Duration(seconds: 1)))
                          .then((_) => UiKitTheme.of(c).onThemeUpdated(themeMatcher(configuration.appConfig.theme)));
                      return const Scaffold(body: Center(child: LoadingWidget()));
                    }),
              // onGenerateRoute: AppRouter.onGenerateRoute,
              // initialRoute: AppRoutes.initial,
            )));
      },
    );
  }
}

class ComponentsTestPage extends StatefulWidget {
  const ComponentsTestPage({Key? key}) : super(key: key);

  @override
  State<ComponentsTestPage> createState() => _ComponentsTestPageState();
}

class _ComponentsTestPageState extends State<ComponentsTestPage> with TickerProviderStateMixin {
  late final likeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1, milliseconds: 500),
    value: 0,
  );

  late final dislikeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1, milliseconds: 500),
    value: 0,
  );

  final GlobalConfiguration configuration = GlobalConfiguration();

  TicketUiModel? ticketModel = TicketUiModel(id: -1);

  List<SubsUiModel> subList = List.generate(
    10,
    (index) => SubsUiModel(
      id: index,
      actualbookingLimit: '1',
      bookingLimit: '10',
      description: 'I am Leonardo Messi, be the best ;)',
      photo: UiKitMediaPhoto(link: GraphicsFoundation.instance.png.story.path),
      title: 'I am Leonardo Messi',
    ),
  );

  List<UpsaleUiModel> upsaleList = List.generate(
    3,
    (index) => UpsaleUiModel(
      id: index,
      limit: '10',
      actualLimit: '3',
      description: 'I am Leonardo Messi, be the best ;)',
      photo: UiKitMediaPhoto(link: GraphicsFoundation.instance.png.lETOLogo.path),
      price: '100',
      currency: 'AED',
    ),
  );
  ValueNotifier<DateTime?> selectedDate = ValueNotifier<DateTime?>(null);

  List<OfferUiModel> _offerUiModelList = [];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    final UiEventModel event = UiEventModel(
      id: 1,
      title: '80’s theme invites only party',
      owner: UiOwnerModel(
        name: 'name',
        // id: '1',
        type: UserTileType.ordinary,
        onTap: () {},
      ),
      bookingUiModel: BookingUiModel(
        showSabsInContentCard: true,
        id: -1,
        subsUiModel: List.generate(
          10,
          (index) => SubsUiModel(
            id: index,
            actualbookingLimit: index.toString(),
            bookingLimit: (index + 1).toString(),
            description: 'I am Leonardo Messi, be the best ;)',
            photo: UiKitMediaPhoto(link: GraphicsFoundation.instance.png.story.path),
            title: 'I am Leonardo Messi',
          ),
        ),
      ),
      media: [
        UiKitMediaVideo(link: 'assets/images/png/place.png'),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
      ],
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
          'Sed euismod, nunc ut tincidunt lacinia, nisl nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
          'Nulla facilisi. '
          'Donec auctor, nisl eget aliquam tincidunt, nunc nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
          'Nulla facilisi',
      rating: 4.8,
      tags: tags,
      location: 'Burj Khalifa 122nd Floor',
      // date: DateTime.now(),
      // dateTo: DateTime(2023, 09, 30),
      // time: TimeOfDay.now(),
      // timeTo: const TimeOfDay(hour: 15, minute: 59),
      weekdays: ['Monday', 'Friday'],

      //   UiDescriptionItemModel(
      //     title: 'Open now',
      //     description: '9:30 am - 10:30 pm',
      //   ),
      // ],
    );

    return Scaffold(
      appBar: CustomAppBar(
        title:
            'Config updated on ${configuration.appConfig.updated.day}/${configuration.appConfig.updated.month} with ${configuration.appConfig.content['version']}',
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show company presentation component',
                    onPressed: () {
                      context.push(CompanyPresentationComponent());
                    })),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show Booking By Visitor Component',
                onPressed: () => context.push(
                  BookingByVisitorComponent(
                    selectedDate: selectedDate,
                    onSubmit: (model, subs, upsale) {
                      setState(() {
                        ticketModel = model;
                        upsaleList = upsale ?? [];
                        subList = subs ?? [];
                      });
                    },
                    onSelectedDate: () async {
                      final selectedDateFromDialog = await showUiKitCalendarDialog(
                        context,
                      );

                      if (selectedDateFromDialog != null) {
                        setState(() {
                          selectedDate?.value = selectedDateFromDialog;
                          log('selectedDate ${selectedDate}');
                        });
                        if (mounted) {
                          final timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (timeOfDay != null) {
                            setState(() {
                              selectedDate.value =
                                  selectedDate?.value?.copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
                              log('selectedDate ${selectedDate}');
                            });
                          }
                        }
                      }
                    },
                    ticketUiModel: ticketModel,
                    bookingUiModel: BookingUiModel(
                      showSabsInContentCard: true,
                      id: -1,
                      price: '500',
                      currency: 'AED',
                      subsUiModel: subList,
                      upsaleUiModel: upsaleList,
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                onPressed: () => context.push(
                  PropertyManagementComponent(
                    propertySearchOptions: (value) async {
                      return ['Active tiger', 'Interested adventure', 'Forever resting sloth', 'Foodie'];
                    },
                    onRecentlyAddedPropertyTapped: (value) {},
                    onPropertyFieldSubmitted: (value) async {
                      return UiModelProperty(
                        title: value,
                        id: 9,
                        icon: null,
                      );
                    },
                    onAddPropertyTypeTap: () {},
                    onDeletePropertyTypeTap: () {},
                    onEditPropertyTypeTap: () {},
                    onPropertyTypeTapped: (value) {},
                    allPropertyCategories: [
                      // UiModelPropertiesCategory(title: 'Active tiger', id: 0),
                      // UiModelPropertiesCategory(title: 'Interested adventure', id: 1),
                      // UiModelPropertiesCategory(title: 'Forever resting sloth', id: 2),
                      // UiModelPropertiesCategory(title: 'Foodie', id: 3),
                    ],
                    basePropertyTypesTap: (int) async {},
                    uniquePropertyTypesTap: (int) async {},
                    relatedProperties: [],
                    selectedPropertyId: 1,
                  ),
                ),
                text: 'show property management component',
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show pro subscription',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(
                    configuration.appConfig.content['pro_account_info'],
                  ),
                  ComponentBuilder(
                    child: AccountSubscriptionComponent(
                      subscriptionFeatures: [
                        SubscriptionDescriptionItem(
                          description: S.of(context).ProSubscriptionFeature2,
                          imagePath: GraphicsFoundation.instance.png.scheduler.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).ProSubscriptionFeature4,
                          imagePath: GraphicsFoundation.instance.png.presale.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).ProSubscriptionFeature5,
                          imagePath: GraphicsFoundation.instance.png.upsales.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).ProSubscriptionFeature6,
                          imagePath: GraphicsFoundation.instance.png.statistics.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).ProSubscriptionFeature7,
                          imagePath: GraphicsFoundation.instance.png.notif.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).ProSubscriptionFeature3,
                          imagePath: GraphicsFoundation.instance.png.pointGift.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature1,
                          imagePath: GraphicsFoundation.instance.png.help.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature5,
                          imagePath: GraphicsFoundation.instance.png.blackWhite.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).ProSubscriptionFeature1,
                          imagePath: GraphicsFoundation.instance.png.pROLabel.path,
                        ),
                      ],
                      configModel: ComponentModel.fromJson(
                        configuration.appConfig.content['pro_account_info'],
                      ),
                      title: 'Pro account',
                      uiModel: UiSubscriptionModel(
                        privacyPolicyUrl: '',
                        termsOfServiceUrl: '',
                        userType: UserTileType.pro,
                        subscriptionFeatures: [
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                        ],
                        userName: 'userName',
                        userAvatarUrl: GraphicsFoundation.instance.png.mockAvatar.path,
                        nickname: 'nickname',
                        offers: [
                          SubscriptionOfferModel(
                            storePurchaseId: '',
                            currency: '\$',
                            savings: 30,
                            price: 13.23,
                            name: 'Yearly',
                            periodName: 'month',
                            trialDaysAvailable: 14,
                          ),
                          SubscriptionOfferModel(
                            storePurchaseId: '',
                            currency: '\$',
                            price: 18.19,
                            name: 'Monthly',
                            periodName: 'month',
                            trialDaysAvailable: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show premium subscription',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(
                    configuration.appConfig.content['premium_account_info'],
                  ),
                  ComponentBuilder(
                    child: AccountSubscriptionComponent(
                      subscriptionFeatures: [
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature1,
                          imagePath: GraphicsFoundation.instance.png.help.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature3,
                          imagePath: GraphicsFoundation.instance.png.reaction.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature4,
                          imagePath: GraphicsFoundation.instance.png.favoritePlace.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature5,
                          imagePath: GraphicsFoundation.instance.png.blackWhite.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature7,
                          imagePath: GraphicsFoundation.instance.png.shareStack.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature8,
                          imagePath: GraphicsFoundation.instance.png.scheduler.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature2,
                          imagePath: GraphicsFoundation.instance.png.shuffleLabel.path,
                        ),
                        SubscriptionDescriptionItem(
                          description: S.of(context).PremiumSubscriptionFeature6,
                          imagePath: GraphicsFoundation.instance.png.influencer.path,
                        ),
                      ],
                      configModel: ComponentModel.fromJson(
                        configuration.appConfig.content['premium_account_info'],
                      ),
                      title: 'Premium account',
                      uiModel: UiSubscriptionModel(
                        privacyPolicyUrl: '',
                        termsOfServiceUrl: '',
                        subscriptionFeatures: [
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                          'lorem ipsum dolor sit amet',
                        ],
                        additionalInfo: const AdditionalInfoPremium(
                          name: 'nickname',
                          userName: 'username',
                        ),
                        userType: UserTileType.premium,
                        userName: 'userName',
                        userAvatarUrl: GraphicsFoundation.instance.png.mockAvatar.path,
                        nickname: 'nickname',
                        offers: [
                          SubscriptionOfferModel(
                            storePurchaseId: '',
                            currency: '\$',
                            savings: 2,
                            price: 4.90,
                            name: 'Annually',
                            periodName: 'month',
                          ),
                          SubscriptionOfferModel(
                            storePurchaseId: '',
                            currency: '\$',
                            price: 5,
                            name: 'Monthly',
                            periodName: 'month',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            // context.button(
            //   data: BaseUiKitButtonData(
            //     text: 'points component',
            //     onPressed: () {
            //       context.push(
            //         PointsComponent(
            //           userType: UserTileType.pro,
            //           uiUserPointsProgressBarModel:
            //               UiUserPointsProgressBarModel(
            //             isMenGender: false,
            //             actual: 90,
            //             level: 2,
            //             sum: 100,
            //           ),
            //           onSpendCallBack: () {},
            //           onHistoryCallBack: () {},
            //           userPointsCount: 2650,
            //           listChallengeFeelings: [
            //             UiPointsModel(
            //               title: S.of(context).Easy,
            //               getPoints: 10,
            //               actualSum: 0,
            //               sum: 10,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgLikeIcon.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgBookingW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).Fair,
            //               getPoints: 20,
            //               actualSum: 4,
            //               sum: 5,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgVictoryHands.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgTwoFingersUpW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).Hardcore,
            //               getPoints: 30,
            //               actualSum: 0,
            //               sum: 1,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgIndexFinger.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgIndexFingerW.path,
            //             ),
            //           ],
            //           listItemPoint: [
            //             UiPointsModel(
            //               title: S.of(context).ShareCard(10),
            //               getPoints: 5,
            //               actualSum: 5,
            //               sum: 10,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation.instance.png.aNoBgShare.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgShareW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).Bookigns(5),
            //               getPoints: 20,
            //               actualSum: 1,
            //               sum: 5,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgBooking.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgBookingW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).LoginInAppDaysInARow(7),
            //               getPoints: 10,
            //               actualSum: 2,
            //               sum: 7,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgWalkingMan.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgWalkingManW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).SpendHoursPerWeek(3),
            //               getPoints: 10,
            //               actualSum: 0.45,
            //               sum: 3,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgHourglass.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgHourglassW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).CardOpening(10),
            //               getPoints: 5,
            //               actualSum: 0,
            //               sum: 1,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation.instance.png.aNoBgEye.path
            //                   : GraphicsFoundation.instance.png.aNoBgEyeW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).FeelingsGuesses(10),
            //               getPoints: 10,
            //               actualSum: 0,
            //               sum: 10,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation.instance.png.aNoBgSmile.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgSmileW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).Connects(10),
            //               getPoints: 15,
            //               actualSum: 0,
            //               sum: 10,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgHandshake.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgHandshakeW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).InvitesCount(20),
            //               showStar: true,
            //               getPoints: 10,
            //               actualSum: 1,
            //               sum: 20,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation.instance.png.aNoBgInvite.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgInviteW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).Feedbacks(10).toLowerCase(),
            //               showStar: true,
            //               getPoints: 5,
            //               actualSum: 5,
            //               sum: 10,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgMessage.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgMessageBubbleW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).ContentOffers(5),
            //               showStar: true,
            //               getPoints: 10,
            //               actualSum: 0,
            //               sum: 1,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgOpenHand.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgOpenHandW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).Reactions(10),
            //               showStar: true,
            //               getPoints: 10,
            //               actualSum: 5,
            //               sum: 10,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation
            //                       .instance.png.aNoBgVideoReaction.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgVideoReactionW.path,
            //             ),
            //             UiPointsModel(
            //               title: S.of(context).StacksShares(5),
            //               showStar: true,
            //               getPoints: 5,
            //               actualSum: 0,
            //               sum: 5,
            //               imagePath: theme?.themeMode == ThemeMode.dark
            //                   ? GraphicsFoundation.instance.png.aNoBgStacks.path
            //                   : GraphicsFoundation
            //                       .instance.png.aNoBgStacksW.path,
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show profile',
                onPressed: () => buildComponent(
                  context,
                  ComponentShuffleModel.fromJson(configuration.appConfig.content['profile']),
                  ComponentBuilder(
                    child: Scaffold(
                      body: ProfileComponent(
                        profile: UiProfileModel(
                          onViewAllAchievements: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Yay! A SnackBar!',
                            ),
                          )),
                          achievements: [
                            UiKitAchievementsModel(
                              title: 'test1',
                              posterUrl:
                                  'https://purepng.com/public/uploads/large/purepng.com-gold-cup-trophygolden-cupgoldtrophymedal-1421526534837pvf6x.png',
                            ),
                            UiKitAchievementsModel(
                              title: 'test2',
                              posterUrl:
                                  'https://purepng.com/public/uploads/large/purepng.com-gold-cup-trophygolden-cupgoldtrophymedal-1421526534837pvf6x.png',
                            ),
                            UiKitAchievementsModel(
                              title: 'test3',
                              posterUrl:
                                  'https://purepng.com/public/uploads/large/purepng.com-gold-cup-trophygolden-cupgoldtrophymedal-1421526534837pvf6x.png',
                            ),
                          ],
                          showSupportShuffle: true,
                          name: 'Marry Williams',
                          nickname: '@marywill',
                          description:
                              'Just walking here and there trying to find something unique and interesting to show you!',
                          avatarUrl: 'assets/images/png/profile_avatar.png',
                          // interests: ['Restaurants', 'Hookah', 'Roller Coaster', 'Swimmings'],
                          // followers: 2650,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'create place',
                    onPressed: () {
                      context.push(Scaffold(
                          body: CreatePlaceComponent(
                        availableTimeTemplates: [],
                        propertiesOptions: (p0) => [],
                        onPlaceCreated: (UiPlaceModel model) async {},
                      )));
                    })),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show My Booking Component',
                onPressed: () {
                  context.push(
                    MyBookingComponent(
                      onAlertCircleTap: (id) {},
                      myBookingUiModel: List.generate(
                        10,
                        (index) => MyBookingUiModel(
                          id: index,
                          name: 'TEst $index',
                          eventModel: index.isEven
                              ? UiEventModel(
                                  id: -1,
                                  currency: 'AED',
                                  description: '',
                                  tags: [],
                                  bookingUiModel: BookingUiModel(
                                    id: -1,
                                    selectedDateTime: DateTime(2024, 8, 1, 15, 45),
                                  ),
                                )
                              : null,
                          placeModel: index.isEven
                              ? null
                              : UiPlaceModel(
                                  id: -1,
                                  description: '',
                                  tags: [],
                                  currency: 'RUB',
                                  bookingUiModel: BookingUiModel(
                                    id: -1,
                                    selectedDateTime: DateTime(2024, 8, 30, 15, 45),
                                  ),
                                ),
                          ticketUiModel: TicketUiModel(
                            ticketsCount: index,
                            id: -1,
                            upsales: [
                              TicketItem(
                                count: 0,
                              ),
                              TicketItem(
                                count: 2,
                              ),
                            ],
                          ),
                          total: 100,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show spent points component',
                onPressed: () => context.push(
                  SpentPointsComponent(
                    balance: 1234,
                    onHistoryTap: () {},
                    onDiscountTap: (value) {},
                    discountsList: List.generate(
                      6,
                      (index) {
                        return UiModelDiscounts(
                          buttonTitle: '30% discount '
                              '(-1500)',
                          barcode: '189576975672367',
                          contentShortUiModel: ContentShortUiModel(
                            imageUrl: GraphicsFoundation.instance.png.place.path,
                            title: 'La Vue Citytel Group',
                            tags: [
                              UiKitTag(
                                title: 'Club',
                                icon: ShuffleUiKitIcons.club,
                                unique: false,
                              ),
                              UiKitTag(
                                title: 'Free',
                                icon: ShuffleUiKitIcons.discount,
                                unique: false,
                              ),
                              UiKitTag(
                                title: 'Closed',
                                icon: ShuffleUiKitIcons.clock,
                                unique: false,
                              ),
                              UiKitTag(
                                title: '7 min',
                                icon: ShuffleUiKitIcons.route,
                                unique: false,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show offers component ',
                onPressed: () => context.push(
                  OffersComponent(
                    listOffers: _offerUiModelList,
                    onCreateOffer: () {
                      context.push(
                        CreateOffer(
                          offerPrice: 5,
                          onCreateOffer: (offerUiModel) async {
                            await payOfferDialog(
                              context,
                              () async {
                                await offerCreatedDialog(context);
                                context.pop();
                              },
                              5,
                            );
                            context.pop();

                            setState(() {
                              _offerUiModelList.add(offerUiModel);
                            });
                          },
                        ),
                      );
                    },
                    onRemoveOffer: (id) {
                      int index = _offerUiModelList.indexWhere((element) => element?.id == id);
                      setState(() {
                        _offerUiModelList.removeAt(index);
                      });
                    },
                    onEditOffer: (id) async {
                      int index = _offerUiModelList.indexWhere((element) => element?.id == id);
                      context.push(
                        CreateOffer(
                          offerPrice: 5,
                          offerUiModel: _offerUiModelList[index],
                          onCreateOffer: (editOfferUiModel) async {
                            if (editOfferUiModel != _offerUiModelList[index]) {
                              await editOfferDialog(
                                context,
                                () {
                                  setState(() {
                                    _offerUiModelList[index] = editOfferUiModel;
                                  });
                                  context.pop();
                                },
                              );
                            }

                            context.pop();
                          },
                        ),
                      );
                    },
                    placeOrEventName: null,
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show create booking component',
                onPressed: () => context.push(
                  CreateBookingComponent(
                    onBookingCreated: (p0) {},
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show place',
                onPressed: () => buildComponent(
                  context,
                  ComponentPlaceModel.fromJson(configuration.appConfig.content['place']),
                  ComponentBuilder(
                    child: PlaceComponent(
                      canLeaveFeedbackCallback: (placeId) async => false,
                      canLeaveFeedbackForEventCallback: (eventId) async => false,
                      place: place.copyWith(
                        bookingUiModel: BookingUiModel(
                          showSabsInContentCard: true,
                          id: -1,
                          subsUiModel: List.generate(
                            10,
                            (index) => SubsUiModel(
                              id: index,
                              actualbookingLimit: index.toString(),
                              bookingLimit: (index + 1).toString(),
                              description: 'I am Leonardo Messi, be the best ;)',
                              photo: UiKitMediaPhoto(link: GraphicsFoundation.instance.png.story.path),
                              title: 'I am Leonardo Messi',
                            ),
                          ),
                        ),
                      ),
                      placeReactionLoaderCallback: (int page, int contentId) async {
                        return [];
                      },
                      eventReactionLoaderCallback: (int page, int contentId) async {
                        return [];
                      },
                      placeFeedbackLoaderCallback: (int page, int contentId) async {
                        return [];
                      },
                      eventFeedbackLoaderCallback: (int page, int contentId) async {
                        return [];
                      },
                    ),
                    bottomBar: BottomBookingBar(
                      model:
                          ComponentPlaceModel.fromJson(configuration.appConfig.content['place']).bookingElementModel ??
                              BookingElementModel(version: '0'),
                      onBook: () {
                        context.push(
                          BookingByVisitorComponent(
                            bookingUiModel: BookingUiModel(
                              showSabsInContentCard: true,
                              id: -1,
                              price: '500',
                              currency: 'AED',
                              subsUiModel: List.generate(
                                10,
                                (index) => SubsUiModel(
                                  id: index,
                                  actualbookingLimit: (math.Random().nextInt(7)).toString(),
                                  bookingLimit: '10',
                                  description: 'I am Leonardo Messi, be the best ;)',
                                  photo: UiKitMediaPhoto(link: GraphicsFoundation.instance.png.story.path),
                                  title: 'I am Leonardo Messi',
                                ),
                              ),
                              upsaleUiModel: List.generate(
                                10,
                                (index) => UpsaleUiModel(
                                  id: index,
                                  limit: '10',
                                  description: 'I am Leonardo Messi, be the best ;)',
                                  photo: UiKitMediaPhoto(link: GraphicsFoundation.instance.png.lETOLogo.path),
                                  price: (math.Random().nextInt(250)).toString(),
                                  actualLimit: (math.Random().nextInt(7)).toString(),
                                  currency: 'AED',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show event',
                onPressed: () => buildComponent(
                  context,
                  ComponentEventModel.fromJson(configuration.appConfig.content['event']),
                  ComponentBuilder(
                    child: EventComponent(
                      canLeaveFeedback: (eventId) async {
                        return false;
                      },
                      event: event,
                      feedbackLoaderCallback: (page, conentId) => [] as Future<List<FeedbackUiModel>>,
                      reactionsLoaderCallback: (page, conentId) => [] as Future<List<VideoReactionUiModel>>,
                    ),
                    bottomBar: BottomBookingBar(
                      model:
                          ComponentPlaceModel.fromJson(configuration.appConfig.content['event']).bookingElementModel ??
                              BookingElementModel(version: '0'),
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show personal credential verification',
                onPressed: () => buildComponent(
                  context,
                  PersonalCredentialVerificationModel.fromJson(
                    configuration.appConfig.content['personal_credentials_verification'],
                  ),
                  ComponentBuilder(
                    child: UnifiedVerificationComponent(
                      uiModel: UiUnifiedVerificationModel(),
                      credentialsController: TextEditingController(),
                      formKey: GlobalKey<FormState>(),
                      passwordController: TextEditingController(),
                      onSocialsLogin: (socialsLoginData) {},
                      onSubmit: (isPersonalSelected) {
                        log('isPersonalSelected $isPersonalSelected');
                      },
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'create event',
                onPressed: () {
                  context.push(
                    Scaffold(
                      body: CreateEventComponent(
                        availableTimeTemplates: [],
                        propertiesOptions: (p0) => [],
                        onEventCreated: (UiEventModel model) async {},
                      ),
                    ),
                  );
                },
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'booking reques',
                onPressed: () {
                  context.push(
                    BookingsControlComponent(
                      onPlaceItemTap: (value) {
                        context.push(
                          BookingsControlUserList(
                            canBookingEdit: true,
                            bookingsPlaceItemUiModel: value,
                            bookingUiModel: BookingUiModel(
                              id: -1,
                              bookingLimit: '10',
                              bookingLimitPerOne: '5',
                            ),
                            onBookingEdit: (model) {
                              context.push(
                                CreateBookingComponent(
                                  onBookingCreated: (value) {},
                                  bookingUiModel: model,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      onEventItemTap: (value) {
                        context.push(
                          BookingsControlUserList(
                            onRequestsRefund: (value) {
                              getRefundBookingDialogUiKit(
                                context: context,
                                userName: value.profile?.name ?? '',
                                allTicket: value.ticketUiModel?.ticketsCount ?? 0,
                                allUpsale: value.ticketUiModel?.totalUpsalesCount ?? 0,
                                ticketRefun: math.Random().nextInt(4) + 1,
                                upsaleRefun: math.Random().nextInt(4) + 1,
                                onContactTap: () {},
                                onGoAheadTap: () {},
                              );
                            },
                            onPopupMenuSelected: (str, userId) {
                              if (str == 'refund') {
                                log('fullRefund $userId');
                              } else if (str == 'partialrefund') {
                                log('partialRefund $userId');
                              } else {
                                showUiKitAlertDialog(
                                  context,
                                  AlertDialogData(
                                    defaultButtonText: '',
                                    insetPadding: EdgeInsets.all(EdgeInsetsFoundation.all24),
                                    title: Text(
                                      '${S.of(context).ContactWith} userName',
                                      style: theme?.boldTextTheme.title2.copyWith(
                                        color: theme.colorScheme.inverseHeadingTypography,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              S.of(context).ByMessage,
                                              style: theme?.boldTextTheme.body.copyWith(
                                                color: theme.colorScheme.inverseBodyTypography,
                                              ),
                                            ),
                                          ),
                                          context.smallOutlinedButton(
                                            data: BaseUiKitButtonData(
                                              borderColor: theme?.colorScheme.primary,
                                              backgroundColor: Colors.transparent,
                                              iconInfo: BaseUiKitButtonIconData(
                                                iconData: ShuffleUiKitIcons.chevronright,
                                                color: theme?.colorScheme.primary,
                                              ),
                                              onPressed: () {},
                                            ),
                                          )
                                        ],
                                      ),
                                      SpacingFoundation.verticalSpace16,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              S.of(context).ByEmail,
                                              style: theme?.boldTextTheme.body.copyWith(
                                                color: theme.colorScheme.inverseBodyTypography,
                                              ),
                                            ),
                                          ),
                                          context.smallOutlinedButton(
                                            data: BaseUiKitButtonData(
                                              borderColor: theme?.colorScheme.primary,
                                              backgroundColor: Colors.transparent,
                                              iconInfo: BaseUiKitButtonIconData(
                                                iconData: ShuffleUiKitIcons.chevronright,
                                                color: theme?.colorScheme.primary,
                                              ),
                                              onPressed: () {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            refundEveryone: (list) {
                              log('list $list');
                            },
                            bookingsPlaceItemUiModel: value,
                            bookingUiModel: BookingUiModel(
                              id: -1,
                              bookingLimit: '10',
                              bookingLimitPerOne: '5',
                            ),
                            onBookingEdit: (model) {
                              context.push(
                                CreateBookingComponent(
                                  onBookingCreated: (value) {},
                                  bookingUiModel: model,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      placesOrEvents: List.generate(
                        12,
                        (index) => BookingsPlaceOrEventUiModel(
                          id: index,
                          title: 'testeMain',
                          description: 'test $index',
                          events: index.isEven
                              ? List.generate(
                                  math.Random().nextInt(5) + 1,
                                  (index) => BookingsPlaceOrEventUiModel(
                                    id: index,
                                    description: 'test $index',
                                    title: 'testeMain',
                                    imageUrl: GraphicsFoundation.instance.png.avatars.avatar3.path,
                                    users: List.generate(
                                      100,
                                      (index) {
                                        return UserBookingsControlUiModel(
                                          id: index,
                                          profile: UiProfileModel(
                                            name: 'test $index',
                                            nickname: '@nickName $index',
                                            avatarUrl: GraphicsFoundation.instance.png.avatars.avatar13.path,
                                            userTileType: index.isEven ? UserTileType.influencer : UserTileType.pro,
                                            email: 'test@emal.index$index',
                                          ),
                                          refundUiModel: index.isEven
                                              ? TicketUiModel.refund(
                                                  ticketsCount: math.Random().nextInt(4) + 1,
                                                  upsales: List.generate(
                                                    3,
                                                    (index) => TicketItem(count: math.Random().nextInt(4) + 1),
                                                  ),
                                                )
                                              : null,
                                          ticketUiModel: TicketUiModel(
                                            id: index,
                                            ticketsCount: math.Random().nextInt(4) + 1,
                                            upsales: List.generate(
                                              2,
                                              (index) => TicketItem(
                                                count: math.Random().nextInt(4) + 1,
                                                item: null,
                                              ),
                                            ),
                                            subs: List.generate(
                                              5,
                                              (index) => TicketItem(
                                                count: math.Random().nextInt(4),
                                                item: null,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<UiKitTag> tags = [
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
    UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
  ];

  final UiUniversalModel item = UiUniversalModel(
      title: 'title',
      id: 1,
      media: [
        UiKitMediaVideo(
          link: 'assets/images/png/place.png',
        ),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
        UiKitMediaPhoto(
          link: 'assets/images/png/place.png',
        ),
      ],
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
          'Sed euismod, nunc ut tincidunt lacinia, nisl nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
          'Nulla facilisi. '
          'Donec auctor, nisl eget aliquam tincidunt, nunc nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
          'Nulla facilisi',
      tags: [
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
        UiKitTag(title: 'uniqueCheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
        UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      ],
      type: '');

  final UiPlaceModel place = UiPlaceModel(
    title: 'title',
    scheduleString: 'Sun: 06:00 pm-08:05 pm',
    id: 1,
    media: [
      UiKitMediaVideo(
        link: 'assets/images/png/place.png',
      ),
      UiKitMediaPhoto(
        link: 'assets/images/png/place.png',
      ),
      UiKitMediaPhoto(
        link: 'assets/images/png/place.png',
      ),
      UiKitMediaPhoto(
        link: 'assets/images/png/place.png',
      ),
      UiKitMediaPhoto(
        link: 'assets/images/png/place.png',
      ),
    ],
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
        'Sed euismod, nunc ut tincidunt lacinia, nisl nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
        'Nulla facilisi. '
        'Donec auctor, nisl eget aliquam tincidunt, nunc nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
        'Nulla facilisi',
    rating: 4.8,
    tags: [
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      UiKitTag(title: 'uniqueCheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: false),
      UiKitTag(title: 'Cheap', icon: ShuffleUiKitIcons.cocktail, unique: true),
    ],

    // descriptionItems: [
    //   const UiDescriptionItemModel(title: 'test 1', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    //   const UiDescriptionItemModel(title: 'test 2', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    //   const UiDescriptionItemModel(title: 'test 3', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    //   const UiDescriptionItemModel(title: 'test 4', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    // ]
  );
}

// SingleChildScrollView(
//     child: Column(
//       children: [
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 onPressed: () => context.push(
//                       PropertyManagementComponent(
//                         propertySearchOptions: (value) async {
//                           return [
//                             'Active tiger',
//                             'Interested adventure',
//                             'Forever resting sloth',
//                             'Foodie'
//                           ];
//                         },
//                         selectedProperties: [
//                           UiModelPropertyType(title: 'Stripes', id: 0),
//                           UiModelPropertyType(title: 'Melomaniac', id: 1),
//                           UiModelPropertyType(title: 'Drinker', id: 2),
//                           UiModelPropertyType(title: 'Smoker', id: 3),
//                         ],
//                         recentlyAddedProperties: [
//                           UiModelPropertyType(title: 'Stripes', id: 0),
//                           UiModelPropertyType(title: 'Melomaniac', id: 1),
//                           UiModelPropertyType(title: 'Drinker', id: 2),
//                           UiModelPropertyType(title: 'Smoker', id: 3),
//                         ],
//                         onRecentlyAddedPropertyTapped: (value) {},
//                         onSelectedPropertyTapped: (value) {},
//                         onPropertyFieldSubmitted: (value) {},
//                         onAddPropertyTypeTap: () {},
//                         onDeletePropertyTypeTap: () {},
//                         onEditPropertyTypeTap: () {},
//                         selectedPropertyTypeTitle: 'Active tiger',
//                         onPropertyTypeTapped: (value) {},
//                         propertyTypes: [
//                           UiModelPropertyType(title: 'Active tiger', id: 0),
//                           UiModelPropertyType(
//                               title: 'Interested adventure', id: 1),
//                           UiModelPropertyType(
//                               title: 'Forever resting sloth', id: 2),
//                           UiModelPropertyType(title: 'Foodie', id: 3),
//                         ],
//                       ),
//                     ),
//                 text: 'show property management component')),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show spent point barcode component',
//             onPressed: () {
//               showUiKitGeneralFullScreenDialog(
//                 context,
//                 GeneralDialogData(
//                   topPadding: 0.35.sh,
//                   child: SpentPointBarcodeComponent(
//                     discountTitle: 'Free coctails',
//                     uiModelDiscounts: UiModelDiscounts(
//                       buttonTitle: '30% discount '
//                           '(-1500)',
//                       barcode: '189576975672367',
//                       contentShortUiModel: ContentShortUiModel(
//                         imageUrl:
//                             GraphicsFoundation.instance.png.place.path,
//                         title: 'La Vue Citytel Group',
//                         tags: [
//                           UiKitTag(
//                             title: 'Club',
//                             icon: ShuffleUiKitIcons.club,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: 'Free',
//                             icon: ShuffleUiKitIcons.discount,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: 'Closed',
//                             icon: ShuffleUiKitIcons.clock,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: '7 min',
//                             icon: ShuffleUiKitIcons.route,
//                             unique: false,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show spent points component',
//             onPressed: () => context.push(
//               SpentPointsComponent(
//                 balance: 1234,
//                 onHistoryTap: () {},
//                 onDiscountTap: (value) {},
//                 discountsList: List.generate(
//                   6,
//                   (index) {
//                     return UiModelDiscounts(
//                       buttonTitle: '30% discount '
//                           '(-1500)',
//                       barcode: '189576975672367',
//                       contentShortUiModel: ContentShortUiModel(
//                         imageUrl:
//                             GraphicsFoundation.instance.png.place.path,
//                         title: 'La Vue Citytel Group',
//                         tags: [
//                           UiKitTag(
//                             title: 'Club',
//                             icon: ShuffleUiKitIcons.club,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: 'Free',
//                             icon: ShuffleUiKitIcons.discount,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: 'Closed',
//                             icon: ShuffleUiKitIcons.clock,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: '7 min',
//                             icon: ShuffleUiKitIcons.route,
//                             unique: false,
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show view history point',
//             onPressed: () => context.push(
//               ViewHistoryPointComponent(
//                 onTapBarCode: () {},
//                 onTabChange: (value) {},
//                 pagingController:
//                     PagingController<int, PointHistoryUniversalModel>(
//                   firstPageKey: 0,
//                 )..appendLastPage(
//                         //when the given List changes, the widget changes as well
//                         //// FOR ACCRUAL TAB
//                         List.generate(
//                           10,
//                           (index) => PointHistoryUniversalModel(
//                             uiModelViewHistoryAccrual:
//                                 UiModelViewHistoryAccrual(
//                               title: 'The Best Parties $index',
//                               date: DateTime.now(),
//                               points: index,
//                             ),
//                           ),
//                         ),
//                         //// FOR ACTIVATION TAB
//                         // List.generate(
//                         //   10,
//                         //   (index) => PointHistoryUniversalModel(
//                         //       contentShortUiModel:
//                         //       ContentShortUiModel(
//                         //     imageUrl:
//                         //         GraphicsFoundation.instance.png.place.path,
//                         //     title: 'La Vue Citytel Group',
//                         //     tags: [
//                         //       UiKitTag(
//                         //         title: 'Club',
//                         //         icon: ShuffleUiKitIcons.club,
//                         //         unique: false,
//                         //       ),
//                         //       UiKitTag(
//                         //         title: 'Free',
//                         //         icon: ShuffleUiKitIcons.discount,
//                         //         unique: false,
//                         //       ),
//                         //       UiKitTag(
//                         //         title: 'Closed',
//                         //         icon: ShuffleUiKitIcons.clock,
//                         //         unique: false,
//                         //       ),
//                         //       UiKitTag(
//                         //         title: '7 min',
//                         //         icon: ShuffleUiKitIcons.route,
//                         //         unique: false,
//                         //       ),
//                         //     ],
//                         //   )),
//                         // ),
//                       ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show favorite merge component',
//             onPressed: () => context.push(
//               FavoritesMergeComponent(
//                 contentsList: List.generate(
//                   3,
//                   (index) {
//                     return UiModelFavoritesMergeContentList(
//                         title: 'The Best Parties $index',
//                         contents: List.generate(
//                           3,
//                           (index) => ContentShortUiModel(
//                             imageUrl:
//                                 GraphicsFoundation.instance.png.place.path,
//                             title: 'La Vue Citytel Group',
//                             tags: [
//                               UiKitTag(
//                                 title: 'Club',
//                                 icon: ShuffleUiKitIcons.club,
//                                 unique: false,
//                               ),
//                               UiKitTag(
//                                 title: 'Free',
//                                 icon: ShuffleUiKitIcons.discount,
//                                 unique: false,
//                               ),
//                               UiKitTag(
//                                 title: 'Closed',
//                                 icon: ShuffleUiKitIcons.clock,
//                                 unique: false,
//                               ),
//                               UiKitTag(
//                                 title: '7 min',
//                                 icon: ShuffleUiKitIcons.route,
//                                 unique: false,
//                               ),
//                             ],
//                           ),
//                         ));
//                   },
//                 ),
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show favorite folders',
//               onPressed: () => context.push(
//                 FavoriteFoldersComponent(
//                   places: List.generate(
//                     4,
//                     (index) => PlacePreview(
//                       onTap: (value) {},
//                       place: UiPlaceModel(
//                         id: index + 1,
//                         media: [
//                           UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
//                           UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
//                           UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
//                           UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
//                         ],
//                         title: 'lorem ipsum dolor sit amet',
//                         description:
//                             'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
//                         baseTags: [
//                           UiKitTag(
//                             title: 'Club',
//                             icon: ShuffleUiKitIcons.club,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: 'Free',
//                             icon: ShuffleUiKitIcons.discount,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: 'Closed',
//                             icon: ShuffleUiKitIcons.clock,
//                             unique: false,
//                           ),
//                           UiKitTag(
//                             title: '7 min',
//                             icon: ShuffleUiKitIcons.route,
//                             unique: false,
//                           ),
//                         ],
//                         tags: [],
//                       ),
//                       isFavorite: Stream<bool>.value(true),
//                       showFavoriteBtn: true,
//                       model: const ComponentModel(pageBuilderType: PageBuilderType.page, version: '1.0.18'),
//                     ),
//                   ),
//                   onShareTap: () {},
//                 ),
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show company feedback chat',
//               onPressed: () => context.push(
//                 FeedbackResponseComponent(
//                   rating: 5,
//                   uiProfileModel: UiProfileModel(name: 'Marry Alliance'),
//                   onMessageTap: () {},
//                   feedBacks: List.generate(
//                     6,
//                     (index) {
//                       return FeedbackResponseUiModel(
//                         id: index,
//                         timeSent: DateTime.now(),
//                         senderIsMe: index.isOdd,
//                         helpfulCount: index.isEven ? 10 : null,
//                         message: index.isOdd
//                             ? 'Good thanks'
//                             : 'Came for lunch with my sister. We loved our Thai-style mains which were amazing with lots of flavour, very impressive for a vegetarian restaurant.But the service was below average and the chips were too terrible to finish.',
//                         senderName: index.isOdd ? 'Burj Khalifa' : 'Marry Alliance',
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show company feedback',
//               onPressed: () => context.push(
//                 CompanyAnswerFeedback(
//                   uiProfileModel: UiProfileModel(
//                     name: 'Marry Alliance',
//                   ),
//                   reviewUiModel: ReviewUiModel(
//                     reviewDescription:
//                         'Came for lunch with my sister. We loved our Thai-style mains which were amazing with lots of flavour, very impressive for a vegetarian restaurant.But the service was below average and the chips were too terrible to finish.',
//                     reviewTime: DateTime.now(),
//                   ),
//                   feedbackTextController: TextEditingController(),
//                   onConfirm: () {},
//                 ),
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//               data: BaseUiKitButtonData(
//                   text: 'show create schedule', onPressed: () => context.push(const CreateScheduleWidget()))),
//           // text: 'show create schedule',
//           // onPressed: () =>
//           //     context.push(const CreateScheduleWidget()))),
//
//           SpacingFoundation.verticalSpace16,
//           context.button(
//               data: BaseUiKitButtonData(
//                   text: 'show create schedule', onPressed: () => context.push(const CreateScheduleWidget()))),
//           SpacingFoundation.verticalSpace16,
//           OrdinaryButton(
//             text: 'show invite Bottom Sheet',
//             onPressed: () => showUiKitGeneralFullScreenDialog(
//               context,
//               GeneralDialogData(
//                 topPadding: 10,
//                 useRootNavigator: false,
//                 child: InviteComponent(
//                   persons: List.generate(
//                     15,
//                     (_) => UiInvitePersonModel(
//                       date: DateTime.now(),
//                       name: 'Marry Williams',
//                       rating: 4,
//                       handshake: true,
//                       avatarLink: GraphicsFoundation.instance.png.mockUserAvatar.path,
//                       description: 'Any cheerful person can invite me',
//                       id: 0,
//                     ),
//                   ),
//                   onLoadMore: () {},
//                   changeDate: () async {
//                     return DateTime.now();
//                   },
//                   onInvitePersonsChanged: (List<UiInvitePersonModel> persons) {},
//                 ),
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show pro subscription',
//               onPressed: () => buildComponent(
//                 context,
//                 ComponentModel.fromJson(
//                   configuration.appConfig.content['pro_account_info'],
//                 ),
//                 ComponentBuilder(
//                   child: AccountSubscriptionComponent(
//                     configModel: ComponentModel.fromJson(
//                       configuration.appConfig.content['pro_account_info'],
//                     ),
//                     title: 'Pro account',
//                     uiModel: UiSubscriptionModel(
//                       privacyPolicyUrl: '',
//                       termsOfServiceUrl: '',
//                       userType: UserTileType.pro,
//                       subscriptionFeatures: [
//                         'lorem ipsum dolor sit amet',
//                         'lorem ipsum dolor sit amet',
//                         'lorem ipsum dolor sit amet',
//                         'lorem ipsum dolor sit amet',
//                         'lorem ipsum dolor sit amet',
//                         'lorem ipsum dolor sit amet',
//                       ],
//                       userName: 'userName',
//                       userAvatarUrl: GraphicsFoundation.instance.png.mockAvatar.path,
//                       nickname: 'nickname',
//                       offers: [
//                         SubscriptionOfferModel(
//                           storePurchaseId: '',
//                           currency: '\$',
//                           savings: 2,
//                           price: 4.49,
//                           name: 'Annually',
//                           periodName: 'month',
//                         ),
//                         SubscriptionOfferModel(
//                           storePurchaseId: '',
//                           currency: '\$',
//                           price: 4.99,
//                           name: 'Monthly',
//                           periodName: 'month',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show create schedule',
//                 onPressed: () =>
//                     context.push(const CreateScheduleWidget()))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show create schedule',
//                 onPressed: () =>
//                     context.push(const CreateScheduleWidget()))),
//         SpacingFoundation.verticalSpace16,
//         OrdinaryButton(
//           text: 'show invite Bottom Sheet',
//           onPressed: () => showUiKitGeneralFullScreenDialog(
//             context,
//             GeneralDialogData(
//               topPadding: 10,
//               useRootNavigator: false,
//               child: InviteComponent(
//                 persons: List.generate(
//                   15,
//                   (_) => UiInvitePersonModel(
//                     date: DateTime.now(),
//                     name: 'Marry Williams',
//                     rating: 4,
//                     handshake: true,
//                     avatarLink:
//                         GraphicsFoundation.instance.png.mockUserAvatar.path,
//                     description: 'Any cheerful person can invite me',
//                     id: 0,
//                   ),
//                 ),
//                 onLoadMore: () {},
//                 changeDate: () async {
//                   return DateTime.now();
//                 },
//                 onInvitePersonsChanged:
//                     (List<UiInvitePersonModel> persons) {},
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show chat screen',
//               onPressed: () {
//                 buildComponent(
//                   context,
//                   ComponentModel.fromJson(
//                     configuration.appConfig.content['chat_page'],
//                   ),
//                   title: 'Pro account',
//                   uiModel: UiSubscriptionModel(
//                     privacyPolicyUrl: '',
//                     termsOfServiceUrl: '',
//                     userType: UserTileType.pro,
//                     subscriptionFeatures: [
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                     ],
//                     userName: 'userName',
//                     userAvatarUrl:
//                         GraphicsFoundation.instance.png.mockAvatar.path,
//                     nickname: 'nickname',
//                     offers: [
//                       SubscriptionOfferModel(
//                         storePurchaseId: '',
//                         currency: '\$',
//                         savings: 2,
//                         price: 4.49,
//                         name: 'Annually',
//                         periodName: 'month',
//                       ),
//                       SubscriptionOfferModel(
//                         storePurchaseId: '',
//                         currency: '\$',
//                         price: 4.99,
//                         name: 'Monthly',
//                         periodName: 'month',
//                       ),
//                       scrollController: ScrollController(),
//                       messageController: TextEditingController(),
//                       pagingController: PagingController<int, ChatMessageUiModel>(
//                         firstPageKey: 1,
//                       )..appendLastPage(
//                           [
//                             ChatMessageUiModel(
//                               messageType: MessageType.message,
//                               senderIsMe: false,
//                               timeSent: DateTime.now(),
//                               message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                             ),
//                             ChatMessageUiModel(
//                               messageType: MessageType.message,
//                               senderIsMe: true,
//                               timeSent: DateTime.now(),
//                               message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                             ),
//                             ChatMessageUiModel(
//                               messageType: MessageType.invitation,
//                               senderIsMe: true,
//                               timeSent: DateTime.now(),
//                               message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                               invitationData: ChatMessageInvitationData(
//                                 username: '@araratjan',
//                                 placeId: 1,
//                                 placeName: 'Burj Khalifa 122nd Floor',
//                                 placeImagePath: GraphicsFoundation.instance.png.place.path,
//                                 invitedPeopleAvatarPaths: [
//                                   GraphicsFoundation.instance.png.inviteMock1.path,
//                                   GraphicsFoundation.instance.png.inviteMock2.path,
//                                   GraphicsFoundation.instance.png.inviteMock3.path,
//                                   GraphicsFoundation.instance.png.inviteMock4.path,
//                                 ],
//                                 tags: [
//                                   UiKitTag(
//                                     title: 'Cheap',
//                                     icon: ShuffleUiKitIcons.cutlery,
//                                   ),
//                                   UiKitTag(
//                                     title: 'Cheap',
//                                     icon: ShuffleUiKitIcons.cutlery,
//                                   ),
//                                   UiKitTag(
//                                     title: 'Cheap',
//                                     icon: ShuffleUiKitIcons.cutlery,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show premium subscription',
//             onPressed: () => buildComponent(
//               context,
//               ComponentModel.fromJson(
//                 configuration.appConfig.content['premium_account_info'],
//               ),
//               ComponentBuilder(
//                 child: AccountSubscriptionComponent(
//                   configModel: ComponentModel.fromJson(
//                     configuration.appConfig.content['premium_account_info'],
//                   ),
//                   title: 'Premium account',
//                   uiModel: UiSubscriptionModel(
//                     privacyPolicyUrl: '',
//                     termsOfServiceUrl: '',
//                     subscriptionFeatures: [
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                       'lorem ipsum dolor sit amet',
//                     ],
//                     userType: UserTileType.premium,
//                     userName: 'userName',
//                     userAvatarUrl:
//                         GraphicsFoundation.instance.png.mockAvatar.path,
//                     nickname: 'nickname',
//                     offers: [
//                       SubscriptionOfferModel(
//                         storePurchaseId: '',
//                         currency: '\$',
//                         savings: 2,
//                         price: 4.90,
//                         name: 'Annually',
//                         periodName: 'month',
//                       ),
//                       SubscriptionOfferModel(
//                         storePurchaseId: '',
//                         currency: '\$',
//                         price: 5,
//                         name: 'Monthly',
//                         periodName: 'month',
//                       ),
//                     onChatSelected: (index) {},
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show feed business',
//               onPressed: () => buildComponent(
//                 context,
//                 ComponentFeedModel.fromJson(
//                   configuration.appConfig.content['feed_business'],
//                 ),
//                 ComponentBuilder(
//                   child: ChatComponent(
//                     chatItemUiModel: ChatItemUiModel(
//                       id: 0,
//                       username: 'username',
//                       nickname: 'nickname',
//                       userType: UserTileType.ordinary,
//                       lastMessage: 'lastMessage',
//                       lastMessageTime: DateTime.now().subtract(
//                         const Duration(days: 2),
//                       ),
//                     ),
//                     scrollController: ScrollController(),
//                     messageController: TextEditingController(),
//                     pagingController:
//                         PagingController<int, ChatMessageUiModel>(
//                       firstPageKey: 1,
//                     )..appendLastPage(
//                             [
//                               ChatMessageUiModel(
//                                 messageType: MessageType.message,
//                                 senderIsMe: false,
//                                 timeSent: DateTime.now(),
//                                 message:
//                                     'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                               ),
//                               ChatMessageUiModel(
//                                 messageType: MessageType.message,
//                                 senderIsMe: true,
//                                 timeSent: DateTime.now(),
//                                 message:
//                                     'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                               ),
//                               ChatMessageUiModel(
//                                 messageType: MessageType.invitation,
//                                 senderIsMe: true,
//                                 timeSent: DateTime.now(),
//                                 message:
//                                     'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                                 invitationData: ChatMessageInvitationData(
//                                   username: '@araratjan',
//                                   placeId: 1,
//                                   placeName: 'Burj Khalifa 122nd Floor',
//                                   placeImagePath: GraphicsFoundation
//                                       .instance.png.place.path,
//                                   invitedPeopleAvatarPaths: [
//                                     GraphicsFoundation
//                                         .instance.png.inviteMock1.path,
//                                     GraphicsFoundation
//                                         .instance.png.inviteMock2.path,
//                                     GraphicsFoundation
//                                         .instance.png.inviteMock3.path,
//                                     GraphicsFoundation
//                                         .instance.png.inviteMock4.path,
//                                   ],
//                                   tags: [
//                                     UiKitTag(
//                                       title: 'Cheap',
//                                       icon: ShuffleUiKitIcons.cutlery,
//                                     ),
//                                     UiKitTag(
//                                       title: 'Cheap',
//                                       icon: ShuffleUiKitIcons.cutlery,
//                                     ),
//                                     UiKitTag(
//                                       title: 'Cheap',
//                                       icon: ShuffleUiKitIcons.cutlery,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show chats screen',
//             onPressed: () => buildComponent(
//               context,
//               ComponentModel.fromJson(
//                 configuration.appConfig.content['chats'],
//               ),
//               ComponentBuilder(
//                 child: AllChatsComponent(
//                   controller: PagingController<int, ChatItemUiModel>(
//                       firstPageKey: 1)
//                     ..appendPage(
//                       List<ChatItemUiModel>.generate(
//                         10,
//                         (index) => ChatItemUiModel(
//                           id: index,
//                           userType: UserTileType.ordinary,
//                           username: 'Araratjan $index',
//                           nickname: '@arajan',
//                           avatarUrl: '',
//                           lastMessage:
//                               'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                           lastMessageTime: DateTime.now()
//                               .subtract(Duration(hours: 6 * index)),
//                           unreadMessageCount: index % 2 == 0 ? index : null,
//                         ),
//                       ),
//                       onTagSortPressed: () {},
//                       onHowItWorksPoped: () {},
//                       onHowItWorksPopedBody: () {},
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show feed business',
//             onPressed: () => buildComponent(
//               context,
//               ComponentFeedModel.fromJson(
//                 configuration.appConfig.content['feed_business'],
//               ),
//               ComponentBuilder(
//                 child: Scaffold(
//                   body: FeedComponent(
//                     showBusinessContent: true,
//                     controller:
//                         PagingController<int, dynamic>(firstPageKey: 1),
//                     feed: UiFeedModel(
//                       recommendedEvent: event,
//                       // moods: List.generate(
//                       //   4,
//                       //       (index) =>
//                       //       UiMoodModel(
//                       //         id: 1,
//                       //         title: 'Want to have some fun',
//                       //         logo: 'assets/images/png/crazy_emoji.png',
//                       //       ),
//                       // ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show search',
//             onPressed: () => buildComponent(
//               context,
//               ComponentModel.fromJson(
//                   configuration.appConfig.content['search']),
//               ComponentBuilder(
//                 child: Scaffold(
//                   body: SearchComponent(
//                     showBusinessContent: false,
//                     searchController: TextEditingController(),
//                     search: UiSearchModel(
//                       heroSearchTag: 'heroSearchTag',
//                       places: List.generate(
//                         10,
//                         (index) => UiPlaceModel(
//                           id: index + 1,
//                           rating: 4 + (index / 10),
//                           media: [
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                           ],
//                           title: 'lorem ipsum dolor sit amet',
//                           description:
//                               'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
//                           baseTags: [
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                           ],
//                           tags: [
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Duh',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Metal',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Heavy',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Club',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Cheaper',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show search for business',
//             onPressed: () => buildComponent(
//               context,
//               ComponentModel.fromJson(
//                   configuration.appConfig.content['search']),
//               ComponentBuilder(
//                 child: Scaffold(
//                   body: SearchComponent(
//                     showBusinessContent: true,
//                     searchController: TextEditingController(),
//                     search: UiSearchModel(
//                       heroSearchTag: 'heroSearchBusinessTag',
//                       places: List.generate(
//                         10,
//                         (index) => UiPlaceModel(
//                           id: index + 1,
//                           rating: 4 + (index / 10),
//                           media: [
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                             UiKitMediaPhoto(
//                                 link: GraphicsFoundation
//                                     .instance.png.place.path),
//                           ],
//                           title: 'lorem ipsum dolor sit amet',
//                           description:
//                               'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
//                           baseTags: [
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: false,
//                             ),
//                           ],
//                           tags: [
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Cheap',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Duh',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Metal',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Heavy',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Club',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                             UiKitTag(
//                               title: 'Cheaper',
//                               icon: ShuffleUiKitIcons.cutlery,
//                               unique: true,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // SpacingFoundation.verticalSpace16,
//           // context.button(
//           //   data: BaseUiKitButtonData(
//           //     text: 'show invite to event',
//           //     onPressed: () =>
//           //         buildComponent(
//           //           context,
//           //           ComponentModel.fromJson(configuration.appConfig.content['invite_people_places']),
//           //           ComponentBuilder(
//           //             child: InviteToFavouritePlacesComponent(
//           //               places: List<UiKitLeadingRadioTile>.generate(
//           //                 10,
//           //                     (index) =>
//           //                     UiKitLeadingRadioTile(
//           //                       title: 'title',
//           //                       avatarLink: GraphicsFoundation.instance.png.inviteMock1.path,
//           //                       tags: [
//           //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
//           //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
//           //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
//           //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
//           //                       ],
//           //                     ),
//           //               ),
//           //               uiModel: UiInviteToFavouritePlacesModel(
//           //                 date: DateTime.now(),
//           //               ),
//           //               onInvite: () {},
//           //               onDatePressed: () {},
//           //             ),
//           //           ),
//           //         ),
//           //   ),
//           // ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//               data: BaseUiKitButtonData(
//                   text: 'create event',
//                   onPressed: () {
//                     context.push(Scaffold(
//                         body: CreateEventComponent(
//                       availableTimeTemplates: [],
//                       propertiesOptions: (p0) => [],
//                       onEventCreated: (UiEventModel model) async {},
//                     )));
//                   })),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//               data: BaseUiKitButtonData(
//                   text: 'create place',
//                   onPressed: () {
//                     context.push(Scaffold(
//                         body: CreatePlaceComponent(
//                       availableTimeTemplates: [],
//                       propertiesOptions: (p0) => [],
//                       onPlaceCreated: (UiPlaceModel model) async {},
//                     )));
//                   })),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show company profile',
//               onPressed: () => buildComponent(
//                 context,
//                 const ComponentModel(
//                   version: '1.0.0',
//                   pageBuilderType: PageBuilderType.page,
//                 ),
//                 ComponentBuilder(
//                   child: CompanyHomeScreenComponent(
//                     profileStats: [
//                       UiKitStats(
//                         title: 'Invited',
//                         value: '934',
//                         actionButton: context.smallButton(
//                           data: BaseUiKitButtonData(
//                             text: 'MORE',
//                             onPressed: () {},
//                           ),
//                         ),
//                       ),
//                       UiKitStats(
//                         title: 'Booked',
//                         value: '133',
//                         actionButton: context.smallButton(
//                           data: BaseUiKitButtonData(
//                             text: 'MORE',
//                             onPressed: () {},
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   name: 'Name asads',
//                   places: List.generate(
//                     2,
//                     (index) => UiPlaceModel(
//                       id: index + 1,
//                       media: [
//                         UiKitMediaPhoto(
//                             link:
//                                 GraphicsFoundation.instance.png.place.path),
//                         UiKitMediaPhoto(
//                             link:
//                                 GraphicsFoundation.instance.png.place.path),
//                         UiKitMediaPhoto(
//                             link:
//                                 GraphicsFoundation.instance.png.place.path),
//                         UiKitMediaPhoto(
//                             link:
//                                 GraphicsFoundation.instance.png.place.path),
//                       ],
//                       title: 'lorem ipsum dolor sit amet',
//                       description:
//                           'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
//                       baseTags: [
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: false,
//                         ),
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: false,
//                         ),
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: false,
//                         ),
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: false,
//                         ),
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: false,
//                         ),
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: false,
//                         ),
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: false,
//                         ),
//                       ],
//                       tags: [
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: true,
//                         ),
//                         UiKitTag(
//                           title: 'Cheap',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: true,
//                         ),
//                         UiKitTag(
//                           title: 'Duh',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: true,
//                         ),
//                         UiKitTag(
//                           title: 'Metal',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: true,
//                         ),
//                         UiKitTag(
//                           title: 'Heavy',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: true,
//                         ),
//                         UiKitTag(
//                           title: 'Club',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: true,
//                         ),
//                         UiKitTag(
//                           title: 'Cheaper',
//                           icon: ShuffleUiKitIcons.cutlery,
//                           unique: true,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show onboarding',
//                 onPressed: () => buildComponent(
//                     context,
//                     ComponentModel.fromJson(
//                         configuration.appConfig.content['onboarding']),
//                     ComponentBuilder(
//                         child: Scaffold(body: OnboardingComponent()))))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show welcome page',
//                 onPressed: () => buildComponent(
//                     context,
//                     ComponentModel.fromJson(
//                         configuration.appConfig.content['welcome']),
//                     ComponentBuilder(
//                         child: Scaffold(
//                             body: WelcomeComponent(
//                       onFinished: () => context.pop(),
//                     )))))),
//         SpacingFoundation.verticalSpace16,
//         // context.button(
//         //     data: BaseUiKitButtonData(
//         //         text: 'show about user step 1',
//         // onPressed: () =>
//         //     buildComponent(
//         //         context,
//         //         ComponentModel.fromJson(configuration.appConfig.content['about_user']),
//         //         ComponentBuilder(
//         //             child: Scaffold(
//         //               body: SafeArea(
//         //                 child: SingleChildScrollView(
//         //                     child: AboutUserComponent(
//         //                       nameController: TextEditingController(),
//         //                       nickNameController: TextEditingController(),
//         //                       aboutUserModel: UiAboutUserModel(),
//         //                     )),
//         //               ),
//         //             ))))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show preferences selector',
//                 onPressed: () => buildComponent(
//                     context,
//                     ComponentShuffleModel.fromJson(
//                         configuration.appConfig.content['about_user']),
//                     ComponentBuilder(
//                         child: Scaffold(
//                             body: PreferencesComponent(
//                       preferences: UiPreferencesModel([
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Electronic\nMusic',
//                             importance: ImportanceChip.high),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Swimming',
//                             importance: ImportanceChip.medium),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Theme\nParks',
//                             importance: ImportanceChip.none),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Hookah',
//                             importance: ImportanceChip.high),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Electronic\nMusic',
//                             importance: ImportanceChip.high),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Swimming',
//                             importance: ImportanceChip.medium),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Theme\nParks',
//                             importance: ImportanceChip.none),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Hookah',
//                             importance: ImportanceChip.high),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Electronic\nMusic',
//                             importance: ImportanceChip.high),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Swimming',
//                             importance: ImportanceChip.medium),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Theme\nParks',
//                             importance: ImportanceChip.none),
//                         UiKitImportanceChip(
//                             id: -1,
//                             title: 'Hookah',
//                             importance: ImportanceChip.high),
//                       ], TextEditingController()),
//                       onSubmit: () {},
//                       onSelect: () {},
//                     )))))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show profile',
//                 onPressed: () => buildComponent(
//                     context,
//                     ComponentShuffleModel.fromJson(
//                         configuration.appConfig.content['profile']),
//                     ComponentBuilder(
//                         child: Scaffold(
//                       body: ProfileComponent(
//                           profile: UiProfileModel(
//                         name: 'Marry Williams',
//                         nickname: '@marywill',
//                         description:
//                             'Just walking here and there trying to find something unique and interesting to show you!',
//                         avatarUrl: 'assets/images/png/profile_avatar.png',
//                         // interests: ['Restaurants', 'Hookah', 'Roller Coaster', 'Swimmings'],
//                         // followers: 2650,
//                       )),
//                     ))))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show shuffle',
//             onPressed: () => buildComponent(
//               context,
//               ComponentShuffleModel.fromJson(
//                   configuration.appConfig.content['shuffle']),
//               ComponentBuilder(
//                 child: Scaffold(
//                   body: ShuffleComponent(
//                     configModel: ComponentShuffleModel.fromJson(
//                         configuration.appConfig.content['shuffle']),
//                     shuffle: UiShuffleModel(
//                       likeController: likeController,
//                       dislikeController: dislikeController,
//                       items: List.generate(
//                         4,
//                         (index) => UiKitSwiperCard(
//                           id: 0,
//                           title: 'Dance Again',
//                           subtitle: 'Unique place for unique people',
//                           imageLink: index == 0
//                               ? 'https://www.vipbeachclubbali.com/wp-content/uploads/2019/05/FINNS-12.jpg'
//                               : index == 1
//                                   ? 'https://www.trutravels.com/blog/finns-beach-club.png'
//                                   : 'https://media.cntraveler.com/photos/59f0e2c6b222cd1c857a0c8a/master/w_1200',
//                           tags: [
//                             const UiKitTagWidget(
//                               title: 'Club',
//                               icon: ShuffleUiKitIcons.cocktail,
//                             ),
//                             UiKitTagWidget(
//                               title: 'Club',
//                               icon: ShuffleUiKitIcons.cocktail,
//                               customSpace:
//                                   SpacingFoundation.horizontalSpace8,
//                               showSpacing: true,
//                             ),
//                             UiKitTagWidget(
//                               title: 'Club',
//                               icon: ShuffleUiKitIcons.cocktail,
//                               customSpace:
//                                   SpacingFoundation.horizontalSpace8,
//                               showSpacing: true,
//                             ),
//                             UiKitTagWidget(
//                               title: 'Club',
//                               icon: ShuffleUiKitIcons.cocktail,
//                               customSpace:
//                                   SpacingFoundation.horizontalSpace8,
//                               showSpacing: true,
//                             ),
//                             UiKitTagWidget(
//                               title: 'Club',
//                               icon: ShuffleUiKitIcons.cocktail,
//                               customSpace:
//                                   SpacingFoundation.horizontalSpace8,
//                               showSpacing: true,
//                             ),
//                           ],
//                         ),
//                       ),
//                       indexNotifier: ValueNotifier<int>(0),
//                       backgroundImageNotifier: ValueNotifier<String>(''),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show company profile',
//             onPressed: () => buildComponent(
//               context,
//               ComponentModel.fromJson(
//                   configuration.appConfig.content['company_profile']),
//               ComponentBuilder(
//                 child: CompanyProfileComponent(
//                   onProfileItemChosen: (value) {},
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         // context.button(
//         //     data: BaseUiKitButtonData(
//         //         text: 'show spinner',
//         //         onPressed: () => buildComponent(
//         //             context,
//         //             ComponentSpinnerModel.fromJson(configuration.appConfig.content['spinner']),
//         //             ComponentBuilder(
//         //                 child: Scaffold(
//         //                     body: SpinnerComponent(
//         //                         onEventTap: () {},
//         //                         onFavoriteTap: () {},
//         //                         spinner: UiSpinnerModel(
//         //                             categories: List<String>.generate(
//         //                               10,
//         //                               (index) => 'Category ${index + 1}',
//         //                             ),
//         //                             events: List.generate(5, (index) => event)))))))),
//         // SpacingFoundation.verticalSpace16,
//         // context.button(
//         //     data: BaseUiKitButtonData(
//         //         text: 'show feed',
//         //         onPressed: () =>
//         //             buildComponent(
//         //                 context,
//         //                 ComponentFeedModel.fromJson(configuration.appConfig.content['feed']),
//         //                 ComponentBuilder(
//         //                     child: Scaffold(
//         //                       // appBar: AppBar(
//         //                       //   backgroundColor: Colors.transparent,
//         //                       //   toolbarHeight: 0,
//         //                       //   bottomOpacity: 0,
//         //                       //   toolbarOpacity: 0,
//         //                       // ),
//         //                         body: SingleChildScrollView(
//         //                             child: FeedComponent(
//         //                                 showBusinessContent: false,
//         //                                 controller: PagingController(firstPageKey: 1),
//         //                                 feed: UiFeedModel(
//         //                                   // mixedItems: List.generate(4, (index) => item),
//         //                                   recommendedEvent: event,
//         //                                   moods: List.generate(
//         //                                       4,
//         //                                           (index) =>
//         //                                           UiMoodModel(
//         //                                             id: 1,
//         //                                             title: 'Want to have some fun',
//         //                                             logo: 'assets/images/png/crazy_emoji.png',
//         //                                           )),
//         //                                 )))))))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show mood',
//             onPressed: () => buildComponent(
//               context,
//               ComponentMoodModel.fromJson(
//                   configuration.appConfig.content['mood']),
//               ComponentBuilder(
//                 child: Scaffold(
//                   appBar: const CustomAppBar(
//                     title: 'Feeling',
//                     centerTitle: true,
//                   ),
//                   body: SingleChildScrollView(
//                     child: MoodComponent(
//                       controller: ScrollController(),
//                       mood: UiMoodModel(
//                         descriptionItems: [
//                           const UiDescriptionItemModel(
//                               active: true,
//                               title: 'Sunny',
//                               description: '+32'),
//                           const UiDescriptionItemModel(
//                               active: true,
//                               title: 'Burned today',
//                               description: '432'),
//                         ],
//                         title: 'need to cool down a bit?',
//                         logo: 'assets/images/png/crazy_emoji.png',
//                         id: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show place',
//                 onPressed: () => buildComponent(
//                     context,
//                     ComponentPlaceModel.fromJson(
//                         configuration.appConfig.content['place']),
//                     ComponentBuilder(
//                         child: PlaceComponent(
//                           place: place,
//                           placeReactionLoaderCallback:
//                               (int page, int contentId) async {
//                             return [];
//                           },
//                           eventReactionLoaderCallback:
//                               (int page, int contentId) async {
//                             return [];
//                           },
//                           placeFeedbackLoaderCallback:
//                               (int page, int contentId) async {
//                             return [];
//                           },
//                           eventFeedbackLoaderCallback:
//                               (int page, int contentId) async {
//                             return [];
//                           },
//                         ),
//                         bottomBar: BottomBookingBar(
//                             model: ComponentPlaceModel.fromJson(
//                                         configuration
//                                             .appConfig.content['place'])
//                                     .bookingElementModel ??
//                                 BookingElementModel(version: '0')))))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//             data: BaseUiKitButtonData(
//                 text: 'show event',
//                 onPressed: () => buildComponent(
//                     context,
//                     ComponentEventModel.fromJson(
//                         configuration.appConfig.content['event']),
//                     ComponentBuilder(
//                         child: EventComponent(
//                           event: event,
//                           feedbackLoaderCallback: (page, conentId) =>
//                               [] as Future<List<FeedbackUiModel>>,
//                           reactionsLoaderCallback: (page, conentId) =>
//                               [] as Future<List<VideoReactionUiModel>>,
//                         ),
//                         bottomBar: BottomBookingBar(
//                             model: ComponentPlaceModel.fromJson(
//                                         configuration
//                                             .appConfig.content['event'])
//                                     .bookingElementModel ??
//                                 BookingElementModel(version: '0')))))),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show user selection',
//             onPressed: () => buildComponent(
//               context,
//               UserTypeSelectionModel.fromJson(
//                   configuration.appConfig.content['user_type_selection']),
//               ComponentBuilder(
//                 child: UserTypeSelectionComponent(
//                   onUserTypeSelected: (userType) {},
//                   uiModel: UiUserTypeSelectionModel(
//                     options: [],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // SpacingFoundation.verticalSpace16,
//           // context.button(
//           //   data: BaseUiKitButtonData(
//           //     text: 'show company registration',
//           //     onPressed: () =>
//           //         buildComponent(
//           //           context,
//           //           ComponentModel.fromJson(configuration.appConfig.content['about_company']),
//           //           ComponentBuilder(
//           //             child: AboutCompanyComponent(
//           //               uiModel: UiAboutCompanyModel(),
//           //               nameController: TextEditingController(),
//           //               positionController: TextEditingController(),
//           //               formKey: GlobalKey<FormState>(),
//           //             ),
//           //           ),
//           //         ),
//           //   ),
//           // ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'show sms verification',
//               onPressed: () => buildComponent(
//                 context,
//                 SmsVerificationModel.fromJson({
//                   'version': '1.0.2',
//                   'builder_type': 'page',
//                 }),
//                 ComponentBuilder(
//                   child: CredentialsCodeVerificationComponent(
//                     codeController: TextEditingController(),
//                     formKey: GlobalKey<FormState>(),
//                     credentials: '+380 66 123 45 67',
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show company credential verification',
//             onPressed: () => buildComponent(
//               context,
//               PersonalCredentialVerificationModel.fromJson(
//                 configuration
//                     .appConfig.content['company_credentials_verification'],
//               ),
//               ComponentBuilder(
//                 child: CompanyCredentialsVerificationComponent(
//                   passwordController: TextEditingController(),
//                   uiModel: UiCompanyCredentialsVerificationModel(),
//                   credentialsController: TextEditingController(),
//                   formKey: GlobalKey<FormState>(),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         context.button(
//           data: BaseUiKitButtonData(
//             text: 'show personal credential verification',
//             onPressed: () => buildComponent(
//               context,
//               PersonalCredentialVerificationModel.fromJson(
//                 configuration
//                     .appConfig.content['personal_credentials_verification'],
//               ),
//               ComponentBuilder(
//                 child: PersonalCredentialsVerificationComponent(
//                   uiModel: UiPersonalCredentialsVerificationModel(),
//                   credentialsController: TextEditingController(),
//                   formKey: GlobalKey<FormState>(),
//                   passwordController: TextEditingController(),
//                 ),
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           OrdinaryButton(
//             text: 'show Donation Bottom Sheet',
//             onPressed: () => showUiKitGeneralFullScreenDialog(
//               context,
//               GeneralDialogData(
//                 useRootNavigator: false,
//                 child: DonationComponent(
//                   onMapTap: () {},
//                   onAskDonationTap: () {},
//                   donationTitle: 'Help me visit Nusr-Et restaurant',
//                   donationNumber: 1,
//                   actualSum: 310,
//                   sum: 900,
//                   topDayUsers: List.generate(
//                     7,
//                     (index) => UiDonationUserModel(
//                       position: index + 1,
//                       sum: '3640',
//                       username: '@misswow2022',
//                       name: 'Natalie White',
//                       points: index < 3 ? '364 000' : null,
//                       userType: UserTileType.influencer,
//                     ),
//                   ),
//                   topMonthUsers: List.generate(
//                     7,
//                     (index) => UiDonationUserModel(
//                       position: index + 1,
//                       sum: '3640',
//                       username: '@misswow2022',
//                       name: 'Natalie',
//                       points: index < 3 ? '364 000' : null,
//                       userType: UserTileType.premium,
//                     ),
//                   ),
//                   topYearUsers: List.generate(
//                     7,
//                     (index) => UiDonationUserModel(
//                       position: index + 1,
//                       sum: '3640',
//                       username: '@misswow2022',
//                       name: 'Natalie White',
//                       points: index < 3 ? '364 000' : null,
//                       userType: UserTileType.pro,
//                     ),
//                   ),
//                   onDonationIndicatorTap: () {},
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         OrdinaryButton(
//           text: 'show price selector component bottom sheet',
//           onPressed: () => showUiKitGeneralFullScreenDialog(
//             context,
//             GeneralDialogData(
//               topPadding: 1.sw <= 380 ? 0.15.sh : 0.40.sh,
//               useRootNavigator: false,
//               child: PriceSelectorComponent(
//                 isPriceRangeSelected: false,
//                 initialCurrency: null,
//                 onSubmit: (averagePrice, rangePrice1, rangePrice2, currency,
//                     averageSelected) {},
//
//                   // text: 'show complaint bottom sheet',
//                   // onPressed: () =>
//                   //     showUiKitGeneralFullScreenDialog(
//                   //       context,
//                   //       GeneralDialogData(
//                   //         topPadding: 0.3.sh,
//                   //         useRootNavigator: false,
//                   //         child: ComplaintFormComponent(
//                   //           onSend: () {},
//                   //           nameController: TextEditingController(),
//                   //           emailController: TextEditingController(),
//                   //           issueController: TextEditingController(),
//                   //           formKey: GlobalKey<FormState>(),
//                   //         ),
//                   //       ),
//                   //     ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         OrdinaryButton(
//           text: 'show price selector component bottom sheet',
//           onPressed: () => showUiKitAlertDialog(
//             context,
//             AlertDialogData(
//               insetPadding: EdgeInsets.zero,
//               defaultButtonSmall: true,
//               customBackgroundColor:
//                   context.uiKitTheme?.colorScheme.surface3,
//               title: Column(
//                 children: [
//                   Container(
//                     alignment: FractionalOffset.topRight,
//                     child: context.iconButtonNoPadding(
//                       data: BaseUiKitButtonData(
//                         iconInfo: BaseUiKitButtonIconData(
//                             iconData: ShuffleUiKitIcons.x, size: 16.0),
//                         onPressed: () => context.pop(),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     S.of(context).SelectPriceAndCurrency,
//                     style: context.uiKitTheme?.regularTextTheme.titleLarge,
//                   ),
//                 ],
//               ),
//               defaultButtonText: '',
//               content: PriceSelectorAdminComponent(
//                 isPriceRangeSelected: false,
//                 initialCurrency: null,
//                 onSubmit: (averagePrice, rangePrice1, rangePrice2, currency,
//                     priceRangeSelected) {
//                   debugPrint(
//                       'averagePrice - $averagePrice, rangePrice1 - $rangePrice1, rangePrice2 - $rangePrice2, currency - $currency, averageSelected - $priceRangeSelected');
//                 },
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           context.button(
//             data: BaseUiKitButtonData(
//               text: 'Select your specialty component',
//               onPressed: () => context.push(
//                 SelectYourSpecialtyComponent(
//                   businessSpecialtyList: [
//                     SelectSpecialty(
//                       name: 'name',
//                       description: 'description',
//                       isSelected: true,
//                     ),
//                     SelectSpecialty(
//                       name: 'name',
//                       description: 'description',
//                       isSelected: false,
//                     ),
//                     SelectSpecialty(
//                       name: 'name',
//                       description: 'description',
//                       isSelected: true,
//                     ),
//                   ],
//                   leisureSpecialtyList: [
//                     SelectSpecialty(
//                       name: 'name',
//                       description: 'description',
//                       isSelected: false,
//                     ),
//                     SelectSpecialty(
//                       name: 'name',
//                       description: 'description',
//                       isSelected: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SpacingFoundation.verticalSpace16,
//         OrdinaryButton(
//           text: 'To become an influencer you need to do:',
//           onPressed: () => showGeneralDialog(
//             context: context,
//             transitionBuilder: (context, animation1, animation2, child) =>
//                 BackdropFilter(
//               filter: ImageFilter.blur(
//                   sigmaX: animation1.value * 30,
//                   sigmaY: animation1.value * 30),
//               child: child,
//             ),
//             pageBuilder: (context, animation1, animation2) =>
//                 FadeTransition(
//               opacity: animation1,
//               child: const ProgressBecomingInfluencerComponent(
//                 reviewsProgress: 47,
//                 videoReactionProgress: 50,
//               ),
//             ),
//           ),
//           SpacingFoundation.verticalSpace16,
//           OrdinaryButton(
//             text: 'show new tool component',
//             onPressed: () => showUiKitGeneralFullScreenDialog(
//               context,
//               GeneralDialogData(
//                 useRootNavigator: false,
//                 child: InfluencerToolsComponent(
//                   onTap: () {},
//                   influencerUiModelList: [
//                     InfluencerToolUiModel(
//                       title: S.of(context).CountReviews(''),
//                       progress: 100,
//                       actualProgress: 50,
//                     ),
//                     InfluencerToolUiModel(
//                       title: S.of(context).CountVideoReaction(''),
//                       progress: 100,
//                       actualProgress: 50,
//                     ),
//                     InfluencerToolUiModel(
//                       title: S.of(context).News,
//                       progress: 50,
//                       actualProgress: 0,
//                     ),
//                     InfluencerToolUiModel(
//                       title: S.of(context).Voices,
//                       progress: 50,
//                       actualProgress: 0,
//                     ),
//                     InfluencerToolUiModel(
//                       title: S.of(context).Photos,
//                       progress: 50,
//                       actualProgress: 0,
//                     ),
//                     InfluencerToolUiModel(
//                       title: S.of(context).IdealRoute,
//                       progress: 5,
//                       actualProgress: 0,
//                     ),
//                   ],
//                   newToolsInfluncerList: [
//                     S.of(context).Photos,
//                     S.of(context).Voices,
//                     S.of(context).News,
//                     S.of(context).IdealRoute,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),