import 'dart:io';
import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {
    final UiEventModel event = UiEventModel(
      id: 1,
      title: '80’s theme invites only party',
      owner: UiOwnerModel(
        name: 'name',
        // id: '1',
        type: UserTileType.ordinary,
        onTap: () {},
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
                text: 'show favorite merge component',
                onPressed: () => context.push(
                  FavoritesMergeComponent(
                    contentsList: List.generate(
                      3,
                      (index) {
                        return UiModelFavoritesMergeContentList(
                            title: 'The Best Parties $index',
                            contents: List.generate(
                              3,
                              (index) => UiModelFavoritesMergeComponent(
                                imageUrl:
                                    GraphicsFoundation.instance.png.place.path,
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
                            ));
                      },
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show favorite folder bottom sheet',
                onPressed: () => showUiKitGeneralFullScreenDialog(
                  context,
                  GeneralDialogData(
                    child: FavoriteFoldersBottomSheetComponent(
                      places: List.generate(
                        4,
                        (index) => PlacePreview(
                          onTap: (value) {},
                          place: UiPlaceModel(
                            id: index + 1,
                            media: [
                              UiKitMediaPhoto(
                                  link: GraphicsFoundation
                                      .instance.png.place.path),
                              UiKitMediaPhoto(
                                  link: GraphicsFoundation
                                      .instance.png.place.path),
                              UiKitMediaPhoto(
                                  link: GraphicsFoundation
                                      .instance.png.place.path),
                              UiKitMediaPhoto(
                                  link: GraphicsFoundation
                                      .instance.png.place.path),
                            ],
                            title: 'lorem ipsum dolor sit amet',
                            description:
                                'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
                            baseTags: [
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
                            tags: [],
                          ),
                          isFavorite: Stream<bool>.value(true),
                          showFavoriteBtn: true,
                          model: const ComponentModel(
                              pageBuilderType: PageBuilderType.page,
                              version: '1.0.18'),
                        ),
                      ),
                      onAddToMyFavorites: () {},
                      personName: 'Kaiya Garcia',
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show favorite create folder',
                onPressed: () => context.push(
                  FavoriteCreateFolderComponent(
                    titleController: TextEditingController(),
                    onConfirm: () {
                      context.pop();
                    },
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show favorite folders',
                onPressed: () => context.push(
                  FavoriteFoldersComponent(
                    places: List.generate(
                      4,
                      (index) => PlacePreview(
                        onTap: (value) {},
                        place: UiPlaceModel(
                          id: index + 1,
                          media: [
                            UiKitMediaPhoto(
                                link:
                                    GraphicsFoundation.instance.png.place.path),
                            UiKitMediaPhoto(
                                link:
                                    GraphicsFoundation.instance.png.place.path),
                            UiKitMediaPhoto(
                                link:
                                    GraphicsFoundation.instance.png.place.path),
                            UiKitMediaPhoto(
                                link:
                                    GraphicsFoundation.instance.png.place.path),
                          ],
                          title: 'lorem ipsum dolor sit amet',
                          description:
                              'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
                          baseTags: [
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
                          tags: [],
                        ),
                        isFavorite: Stream<bool>.value(true),
                        showFavoriteBtn: true,
                        model: const ComponentModel(
                            pageBuilderType: PageBuilderType.page,
                            version: '1.0.18'),
                      ),
                    ),
                    onShareTap: () {},
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show company feedback chat',
                onPressed: () => context.push(
                  FeedbackResponseComponent(
                    rating: 5,
                    uiProfileModel: UiProfileModel(name: 'Marry Alliance'),
                    onMessageTap: () {},
                    feedBacks: List.generate(
                      6,
                      (index) {
                        return FeedbackResponseUiModel(
                          id: index,
                          timeSent: DateTime.now(),
                          senderIsMe: index.isOdd,
                          helpfulCount: index.isEven ? 10 : null,
                          message: index.isOdd
                              ? 'Good thanks'
                              : 'Came for lunch with my sister. We loved our Thai-style mains which were amazing with lots of flavour, very impressive for a vegetarian restaurant.But the service was below average and the chips were too terrible to finish.',
                          senderName:
                              index.isOdd ? 'Burj Khalifa' : 'Marry Alliance',
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
                text: 'show company feedback',
                onPressed: () => context.push(
                  CompanyAnswerFeedback(
                    uiProfileModel: UiProfileModel(
                      name: 'Marry Alliance',
                    ),
                    reviewUiModel: ReviewUiModel(
                      reviewDescription:
                          'Came for lunch with my sister. We loved our Thai-style mains which were amazing with lots of flavour, very impressive for a vegetarian restaurant.But the service was below average and the chips were too terrible to finish.',
                      reviewTime: DateTime.now(),
                    ),
                    feedbackTextController: TextEditingController(),
                    onConfirm: () {},
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show create schedule', onPressed: () => context.push(const CreateScheduleWidget()))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show create schedule',
                    onPressed: () =>
                        context.push(const CreateScheduleWidget()))),
            SpacingFoundation.verticalSpace16,
            OrdinaryButton(
              text: 'show invite Bottom Sheet',
              onPressed: () => showUiKitGeneralFullScreenDialog(
                context,
                GeneralDialogData(
                  topPadding: 10,
                  useRootNavigator: false,
                  child: InviteComponent(
                    persons: List.generate(
                      15,
                      (_) => UiInvitePersonModel(
                        date: DateTime.now(),
                        name: 'Marry Williams',
                        rating: 4,
                        handshake: true,
                        avatarLink: GraphicsFoundation.instance.png.mockUserAvatar.path,
                        description: 'Any cheerful person can invite me',
                        id: 0,
                      ),
                    ),
                    onLoadMore: () {},
                    changeDate: () async {
                      return DateTime.now();
                    },
                    onInvitePersonsChanged: (List<UiInvitePersonModel> persons) {},
                  ),
                ),
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
                            savings: 2,
                            price: 4.49,
                            name: 'Annually',
                            periodName: 'month',
                          ),
                          SubscriptionOfferModel(
                            storePurchaseId: '',
                            currency: '\$',
                            price: 4.99,
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
            context.button(
              data: BaseUiKitButtonData(
                text: 'show chat screen',
                onPressed: () {
                  buildComponent(
                    context,
                    ComponentModel.fromJson(
                      configuration.appConfig.content['chat_page'],
                    ),
                    ComponentBuilder(
                      child: ChatComponent(
                        chatItemUiModel: ChatItemUiModel(
                          id: 0,
                          username: 'username',
                          nickname: 'nickname',
                          userType: UserTileType.ordinary,
                          lastMessage: 'lastMessage',
                          lastMessageTime: DateTime.now().subtract(
                            const Duration(days: 2),
                          ),
                        ),
                        scrollController: ScrollController(),
                        messageController: TextEditingController(),
                        pagingController: PagingController<int, ChatMessageUiModel>(
                          firstPageKey: 1,
                        )..appendLastPage(
                            [
                              ChatMessageUiModel(
                                messageType: MessageType.message,
                                senderIsMe: false,
                                timeSent: DateTime.now(),
                                message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                              ),
                              ChatMessageUiModel(
                                messageType: MessageType.message,
                                senderIsMe: true,
                                timeSent: DateTime.now(),
                                message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                              ),
                              ChatMessageUiModel(
                                messageType: MessageType.invitation,
                                senderIsMe: true,
                                timeSent: DateTime.now(),
                                message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                                invitationData: ChatMessageInvitationData(
                                  username: '@araratjan',
                                  placeId: 1,
                                  placeName: 'Burj Khalifa 122nd Floor',
                                  placeImagePath: GraphicsFoundation.instance.png.place.path,
                                  invitedPeopleAvatarPaths: [
                                    GraphicsFoundation.instance.png.inviteMock1.path,
                                    GraphicsFoundation.instance.png.inviteMock2.path,
                                    GraphicsFoundation.instance.png.inviteMock3.path,
                                    GraphicsFoundation.instance.png.inviteMock4.path,
                                  ],
                                  tags: [
                                    UiKitTag(
                                      title: 'Cheap',
                                      icon: ShuffleUiKitIcons.cutlery,
                                    ),
                                    UiKitTag(
                                      title: 'Cheap',
                                      icon: ShuffleUiKitIcons.cutlery,
                                    ),
                                    UiKitTag(
                                      title: 'Cheap',
                                      icon: ShuffleUiKitIcons.cutlery,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                text: 'show chats screen',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(
                    configuration.appConfig.content['chats'],
                  ),
                  ComponentBuilder(
                    child: AllChatsComponent(
                      controller: PagingController<int, ChatItemUiModel>(firstPageKey: 1)
                        ..appendPage(
                          List<ChatItemUiModel>.generate(
                            10,
                            (index) => ChatItemUiModel(
                              id: index,
                              userType: UserTileType.ordinary,
                              username: 'Araratjan $index',
                              nickname: '@arajan',
                              avatarUrl: '',
                              lastMessage: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                              lastMessageTime: DateTime.now().subtract(Duration(hours: 6 * index)),
                              unreadMessageCount: index % 2 == 0 ? index : null,
                            ),
                          ),
                          2,
                        ),
                      onChatSelected: (index) {},
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show feed business',
                onPressed: () => buildComponent(
                  context,
                  ComponentFeedModel.fromJson(
                    configuration.appConfig.content['feed_business'],
                  ),
                  ComponentBuilder(
                    child: Scaffold(
                      body: FeedComponent(
                        showBusinessContent: true,
                        controller: PagingController<int, dynamic>(firstPageKey: 1),
                        feed: UiFeedModel(
                          recommendedEvent: event,
                          // moods: List.generate(
                          //   4,
                          //       (index) =>
                          //       UiMoodModel(
                          //         id: 1,
                          //         title: 'Want to have some fun',
                          //         logo: 'assets/images/png/crazy_emoji.png',
                          //       ),
                          // ),
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
                text: 'show search',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(configuration.appConfig.content['search']),
                  ComponentBuilder(
                    child: Scaffold(
                      body: SearchComponent(
                        showBusinessContent: false,
                        searchController: TextEditingController(),
                        search: UiSearchModel(
                          heroSearchTag: 'heroSearchTag',
                          places: List.generate(
                            10,
                            (index) => UiPlaceModel(
                              id: index + 1,
                              rating: 4 + (index / 10),
                              media: [
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                              ],
                              title: 'lorem ipsum dolor sit amet',
                              description:
                                  'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
                              baseTags: [
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                              ],
                              tags: [
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Duh',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Metal',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Heavy',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Club',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheaper',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                              ],
                            ),
                          ),
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
                text: 'show search for business',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(configuration.appConfig.content['search']),
                  ComponentBuilder(
                    child: Scaffold(
                      body: SearchComponent(
                        showBusinessContent: true,
                        searchController: TextEditingController(),
                        search: UiSearchModel(
                          heroSearchTag: 'heroSearchBusinessTag',
                          places: List.generate(
                            10,
                            (index) => UiPlaceModel(
                              id: index + 1,
                              rating: 4 + (index / 10),
                              media: [
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                                UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                              ],
                              title: 'lorem ipsum dolor sit amet',
                              description:
                                  'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
                              baseTags: [
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: false,
                                ),
                              ],
                              tags: [
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Duh',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Metal',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Heavy',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Club',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheaper',
                                  icon: ShuffleUiKitIcons.cutlery,
                                  unique: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SpacingFoundation.verticalSpace16,
            // context.button(
            //   data: BaseUiKitButtonData(
            //     text: 'show invite to event',
            //     onPressed: () =>
            //         buildComponent(
            //           context,
            //           ComponentModel.fromJson(configuration.appConfig.content['invite_people_places']),
            //           ComponentBuilder(
            //             child: InviteToFavouritePlacesComponent(
            //               places: List<UiKitLeadingRadioTile>.generate(
            //                 10,
            //                     (index) =>
            //                     UiKitLeadingRadioTile(
            //                       title: 'title',
            //                       avatarLink: GraphicsFoundation.instance.png.inviteMock1.path,
            //                       tags: [
            //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
            //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
            //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
            //                         UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
            //                       ],
            //                     ),
            //               ),
            //               uiModel: UiInviteToFavouritePlacesModel(
            //                 date: DateTime.now(),
            //               ),
            //               onInvite: () {},
            //               onDatePressed: () {},
            //             ),
            //           ),
            //         ),
            //   ),
            // ),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'create event',
                    onPressed: () {
                      context.push(Scaffold(
                          body: CreateEventComponent(
                        availableTimeTemplates: [],
                        propertiesOptions: (p0) => [],
                        onEventCreated: (UiEventModel model) async {},
                      )));
                    })),
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
                text: 'show company profile',
                onPressed: () => buildComponent(
                  context,
                  const ComponentModel(
                    version: '1.0.0',
                    pageBuilderType: PageBuilderType.page,
                  ),
                  ComponentBuilder(
                    child: CompanyHomeScreenComponent(
                      profileStats: [
                        UiKitStats(
                          title: 'Invited',
                          value: '934',
                          actionButton: context.smallButton(
                            data: BaseUiKitButtonData(
                              text: 'MORE',
                              onPressed: () {},
                            ),
                          ),
                        ),
                        UiKitStats(
                          title: 'Booked',
                          value: '133',
                          actionButton: context.smallButton(
                            data: BaseUiKitButtonData(
                              text: 'MORE',
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                      name: 'Name asads',
                      places: List.generate(
                        2,
                        (index) => UiPlaceModel(
                          id: index + 1,
                          media: [
                            UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                            UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                            UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                            UiKitMediaPhoto(link: GraphicsFoundation.instance.png.place.path),
                          ],
                          title: 'lorem ipsum dolor sit amet',
                          description:
                              'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
                          baseTags: [
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: false,
                            ),
                          ],
                          tags: [
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Duh',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Metal',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Heavy',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Club',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Cheaper',
                              icon: ShuffleUiKitIcons.cutlery,
                              unique: true,
                            ),
                          ],
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
                    text: 'show onboarding',
                    onPressed: () => buildComponent(
                        context,
                        ComponentModel.fromJson(configuration.appConfig.content['onboarding']),
                        ComponentBuilder(child: Scaffold(body: OnboardingComponent()))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show welcome page',
                    onPressed: () => buildComponent(
                        context,
                        ComponentModel.fromJson(configuration.appConfig.content['welcome']),
                        ComponentBuilder(
                            child: Scaffold(
                                body: WelcomeComponent(
                          onFinished: () => context.pop(),
                        )))))),
            SpacingFoundation.verticalSpace16,
            // context.button(
            //     data: BaseUiKitButtonData(
            //         text: 'show about user step 1',
            // onPressed: () =>
            //     buildComponent(
            //         context,
            //         ComponentModel.fromJson(configuration.appConfig.content['about_user']),
            //         ComponentBuilder(
            //             child: Scaffold(
            //               body: SafeArea(
            //                 child: SingleChildScrollView(
            //                     child: AboutUserComponent(
            //                       nameController: TextEditingController(),
            //                       nickNameController: TextEditingController(),
            //                       aboutUserModel: UiAboutUserModel(),
            //                     )),
            //               ),
            //             ))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show preferences selector',
                    onPressed: () => buildComponent(
                        context,
                        ComponentShuffleModel.fromJson(configuration.appConfig.content['about_user']),
                        ComponentBuilder(
                            child: Scaffold(
                                body: PreferencesComponent(
                          preferences: UiPreferencesModel([
                            UiKitImportanceChip(id: -1, title: 'Electronic\nMusic', importance: ImportanceChip.high),
                            UiKitImportanceChip(id: -1, title: 'Swimming', importance: ImportanceChip.medium),
                            UiKitImportanceChip(id: -1, title: 'Theme\nParks', importance: ImportanceChip.none),
                            UiKitImportanceChip(id: -1, title: 'Hookah', importance: ImportanceChip.high),
                            UiKitImportanceChip(id: -1, title: 'Electronic\nMusic', importance: ImportanceChip.high),
                            UiKitImportanceChip(id: -1, title: 'Swimming', importance: ImportanceChip.medium),
                            UiKitImportanceChip(id: -1, title: 'Theme\nParks', importance: ImportanceChip.none),
                            UiKitImportanceChip(id: -1, title: 'Hookah', importance: ImportanceChip.high),
                            UiKitImportanceChip(id: -1, title: 'Electronic\nMusic', importance: ImportanceChip.high),
                            UiKitImportanceChip(id: -1, title: 'Swimming', importance: ImportanceChip.medium),
                            UiKitImportanceChip(id: -1, title: 'Theme\nParks', importance: ImportanceChip.none),
                            UiKitImportanceChip(id: -1, title: 'Hookah', importance: ImportanceChip.high),
                          ], TextEditingController()),
                          onSubmit: () {},
                          onSelect: () {},
                        )))))),
            SpacingFoundation.verticalSpace16,
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
                            name: 'Marry Williams',
                            nickname: '@marywill',
                            description:
                                'Just walking here and there trying to find something unique and interesting to show you!',
                            avatarUrl: 'assets/images/png/profile_avatar.png',
                            // interests: ['Restaurants', 'Hookah', 'Roller Coaster', 'Swimmings'],
                            // followers: 2650,
                          )),
                        ))))),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show shuffle',
                onPressed: () => buildComponent(
                  context,
                  ComponentShuffleModel.fromJson(configuration.appConfig.content['shuffle']),
                  ComponentBuilder(
                    child: Scaffold(
                      body: ShuffleComponent(
                        configModel: ComponentShuffleModel.fromJson(configuration.appConfig.content['shuffle']),
                        shuffle: UiShuffleModel(
                          likeController: likeController,
                          dislikeController: dislikeController,
                          items: List.generate(
                            4,
                            (index) => UiKitSwiperCard(
                              id: 0,
                              title: 'Dance Again',
                              subtitle: 'Unique place for unique people',
                              imageLink: index == 0
                                  ? 'https://www.vipbeachclubbali.com/wp-content/uploads/2019/05/FINNS-12.jpg'
                                  : index == 1
                                      ? 'https://www.trutravels.com/blog/finns-beach-club.png'
                                      : 'https://media.cntraveler.com/photos/59f0e2c6b222cd1c857a0c8a/master/w_1200',
                              tags: [
                                const UiKitTagWidget(
                                  title: 'Club',
                                  icon: ShuffleUiKitIcons.cocktail,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: ShuffleUiKitIcons.cocktail,
                                  customSpace: SpacingFoundation.horizontalSpace8,
                                  showSpacing: true,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: ShuffleUiKitIcons.cocktail,
                                  customSpace: SpacingFoundation.horizontalSpace8,
                                  showSpacing: true,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: ShuffleUiKitIcons.cocktail,
                                  customSpace: SpacingFoundation.horizontalSpace8,
                                  showSpacing: true,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: ShuffleUiKitIcons.cocktail,
                                  customSpace: SpacingFoundation.horizontalSpace8,
                                  showSpacing: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        indexNotifier: ValueNotifier<int>(0),
                        backgroundImageNotifier: ValueNotifier<String>(''),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show company profile',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(configuration.appConfig.content['company_profile']),
                  ComponentBuilder(
                    child: CompanyProfileComponent(
                      onProfileItemChosen: (value) {},
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            // context.button(
            //     data: BaseUiKitButtonData(
            //         text: 'show spinner',
            //         onPressed: () => buildComponent(
            //             context,
            //             ComponentSpinnerModel.fromJson(configuration.appConfig.content['spinner']),
            //             ComponentBuilder(
            //                 child: Scaffold(
            //                     body: SpinnerComponent(
            //                         onEventTap: () {},
            //                         onFavoriteTap: () {},
            //                         spinner: UiSpinnerModel(
            //                             categories: List<String>.generate(
            //                               10,
            //                               (index) => 'Category ${index + 1}',
            //                             ),
            //                             events: List.generate(5, (index) => event)))))))),
            // SpacingFoundation.verticalSpace16,
            // context.button(
            //     data: BaseUiKitButtonData(
            //         text: 'show feed',
            //         onPressed: () =>
            //             buildComponent(
            //                 context,
            //                 ComponentFeedModel.fromJson(configuration.appConfig.content['feed']),
            //                 ComponentBuilder(
            //                     child: Scaffold(
            //                       // appBar: AppBar(
            //                       //   backgroundColor: Colors.transparent,
            //                       //   toolbarHeight: 0,
            //                       //   bottomOpacity: 0,
            //                       //   toolbarOpacity: 0,
            //                       // ),
            //                         body: SingleChildScrollView(
            //                             child: FeedComponent(
            //                                 showBusinessContent: false,
            //                                 controller: PagingController(firstPageKey: 1),
            //                                 feed: UiFeedModel(
            //                                   // mixedItems: List.generate(4, (index) => item),
            //                                   recommendedEvent: event,
            //                                   moods: List.generate(
            //                                       4,
            //                                           (index) =>
            //                                           UiMoodModel(
            //                                             id: 1,
            //                                             title: 'Want to have some fun',
            //                                             logo: 'assets/images/png/crazy_emoji.png',
            //                                           )),
            //                                 )))))))),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show mood',
                onPressed: () => buildComponent(
                  context,
                  ComponentMoodModel.fromJson(configuration.appConfig.content['mood']),
                  ComponentBuilder(
                    child: Scaffold(
                      appBar: const CustomAppBar(
                        title: 'Feeling',
                        centerTitle: true,
                      ),
                      body: SingleChildScrollView(
                        child: MoodComponent(
                          controller: ScrollController(),
                          mood: UiMoodModel(
                            descriptionItems: [
                              const UiDescriptionItemModel(active: true, title: 'Sunny', description: '+32'),
                              const UiDescriptionItemModel(active: true, title: 'Burned today', description: '432'),
                            ],
                            title: 'need to cool down a bit?',
                            logo: 'assets/images/png/crazy_emoji.png',
                            id: 1,
                          ),
                          onTabChanged: (String name) {
                            return null;
                          },
                          isVisibleButton: ValueNotifier<bool>(true),
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
                    text: 'show place',
                    onPressed: () => buildComponent(
                        context,
                        ComponentPlaceModel.fromJson(configuration.appConfig.content['place']),
                        ComponentBuilder(
                            child: PlaceComponent(
                              place: place,
                              placeReactionLoaderCallback:
                                  (int page, int contentId) async {
                                return [];
                              },
                              eventReactionLoaderCallback:
                                  (int page, int contentId) async {
                                return [];
                              },
                              placeFeedbackLoaderCallback:
                                  (int page, int contentId) async {
                                return [];
                              },
                              eventFeedbackLoaderCallback:
                                  (int page, int contentId) async {
                                return [];
                              },
                            ),
                            bottomBar: BottomBookingBar(
                                model: ComponentPlaceModel.fromJson(configuration.appConfig.content['place'])
                                        .bookingElementModel ??
                                    BookingElementModel(version: '0')))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show event',
                    onPressed: () => buildComponent(
                        context,
                        ComponentEventModel.fromJson(configuration.appConfig.content['event']),
                        ComponentBuilder(
                            child: EventComponent(
                              event: event,
                              feedbackLoaderCallback: (page, conentId) => [] as Future<List<FeedbackUiModel>>,
                              reactionsLoaderCallback: (page, conentId) => [] as Future<List<VideoReactionUiModel>>,
                            ),
                            bottomBar: BottomBookingBar(
                                model: ComponentPlaceModel.fromJson(configuration.appConfig.content['event'])
                                        .bookingElementModel ??
                                    BookingElementModel(version: '0')))))),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show user selection',
                onPressed: () => buildComponent(
                  context,
                  UserTypeSelectionModel.fromJson(configuration.appConfig.content['user_type_selection']),
                  ComponentBuilder(
                    child: UserTypeSelectionComponent(
                      onUserTypeSelected: (userType) {},
                      uiModel: UiUserTypeSelectionModel(
                        options: [],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SpacingFoundation.verticalSpace16,
            // context.button(
            //   data: BaseUiKitButtonData(
            //     text: 'show company registration',
            //     onPressed: () =>
            //         buildComponent(
            //           context,
            //           ComponentModel.fromJson(configuration.appConfig.content['about_company']),
            //           ComponentBuilder(
            //             child: AboutCompanyComponent(
            //               uiModel: UiAboutCompanyModel(),
            //               nameController: TextEditingController(),
            //               positionController: TextEditingController(),
            //               formKey: GlobalKey<FormState>(),
            //             ),
            //           ),
            //         ),
            //   ),
            // ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show sms verification',
                onPressed: () => buildComponent(
                  context,
                  SmsVerificationModel.fromJson({
                    'version': '1.0.2',
                    'builder_type': 'page',
                  }),
                  ComponentBuilder(
                    child: CredentialsCodeVerificationComponent(
                      codeController: TextEditingController(),
                      formKey: GlobalKey<FormState>(),
                      credentials: '+380 66 123 45 67',
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show company credential verification',
                onPressed: () => buildComponent(
                  context,
                  PersonalCredentialVerificationModel.fromJson(
                    configuration.appConfig.content['company_credentials_verification'],
                  ),
                  ComponentBuilder(
                    child: CompanyCredentialsVerificationComponent(
                      passwordController: TextEditingController(),
                      uiModel: UiCompanyCredentialsVerificationModel(),
                      credentialsController: TextEditingController(),
                      formKey: GlobalKey<FormState>(),
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
                    child: PersonalCredentialsVerificationComponent(
                      uiModel: UiPersonalCredentialsVerificationModel(),
                      credentialsController: TextEditingController(),
                      formKey: GlobalKey<FormState>(),
                      passwordController: TextEditingController(),
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            OrdinaryButton(
              text: 'show Donation Bottom Sheet',
              onPressed: () => showUiKitGeneralFullScreenDialog(
                context,
                GeneralDialogData(
                  useRootNavigator: false,
                  child: DonationComponent(
                    onMapTap: () {},
                    onAskDonationTap: () {},
                    donationTitle: 'Help me visit Nusr-Et restaurant',
                    donationNumber: 1,
                    actualSum: 310,
                    sum: 900,
                    topDayUsers: List.generate(
                      7,
                      (index) => UiDonationUserModel(
                        position: index + 1,
                        sum: '3640',
                        username: '@misswow2022',
                        name: 'Natalie White',
                        points: index < 3 ? '364 000' : null,
                        userType: UserTileType.influencer,
                      ),
                    ),
                    topMonthUsers: List.generate(
                      7,
                      (index) => UiDonationUserModel(
                        position: index + 1,
                        sum: '3640',
                        username: '@misswow2022',
                        name: 'Natalie',
                        points: index < 3 ? '364 000' : null,
                        userType: UserTileType.premium,
                      ),
                    ),
                    topYearUsers: List.generate(
                      7,
                      (index) => UiDonationUserModel(
                        position: index + 1,
                        sum: '3640',
                        username: '@misswow2022',
                        name: 'Natalie White',
                        points: index < 3 ? '364 000' : null,
                        userType: UserTileType.pro,
                      ),
                    ),
                    onDonationIndicatorTap: () {},
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            OrdinaryButton(
              text: 'show price selector component bottom sheet',
              onPressed: () => showUiKitGeneralFullScreenDialog(
                context,
                GeneralDialogData(
                  topPadding: 1.sw <= 380 ? 0.15.sh : 0.40.sh,
                  useRootNavigator: false,
                  child: PriceSelectorComponent(
                    isPriceRangeSelected: false,
                    initialCurrency: null,
                    onSubmit: (averagePrice, rangePrice1, rangePrice2, currency, averageSelected) {},

                    // text: 'show complaint bottom sheet',
                    // onPressed: () =>
                    //     showUiKitGeneralFullScreenDialog(
                    //       context,
                    //       GeneralDialogData(
                    //         topPadding: 0.3.sh,
                    //         useRootNavigator: false,
                    //         child: ComplaintFormComponent(
                    //           onSend: () {},
                    //           nameController: TextEditingController(),
                    //           emailController: TextEditingController(),
                    //           issueController: TextEditingController(),
                    //           formKey: GlobalKey<FormState>(),
                    //         ),
                    //       ),
                    //     ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            OrdinaryButton(
              text: 'show price selector component bottom sheet',
              onPressed: () => showUiKitAlertDialog(
                context,
                AlertDialogData(
                  insetPadding: EdgeInsets.zero,
                  defaultButtonSmall: true,
                  customBackgroundColor: context.uiKitTheme?.colorScheme.surface3,
                  title: Column(
                    children: [
                      Container(
                        alignment: FractionalOffset.topRight,
                        child: context.iconButtonNoPadding(
                          data: BaseUiKitButtonData(
                            iconInfo: BaseUiKitButtonIconData(iconData: ShuffleUiKitIcons.x, size: 16.0),
                            onPressed: () => context.pop(),
                          ),
                        ),
                      ),
                      Text(
                        S.of(context).SelectPriceAndCurrency,
                        style: context.uiKitTheme?.regularTextTheme.titleLarge,
                      ),
                    ],
                  ),
                  defaultButtonText: '',
                  content: PriceSelectorAdminComponent(
                    isPriceRangeSelected: false,
                    initialCurrency: null,
                    onSubmit: (averagePrice, rangePrice1, rangePrice2, currency, priceRangeSelected) {
                      debugPrint(
                          'averagePrice - $averagePrice, rangePrice1 - $rangePrice1, rangePrice2 - $rangePrice2, currency - $currency, averageSelected - $priceRangeSelected');
                    },
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'Select your specialty component',
                onPressed: () => context.push(
                  SelectYourSpecialtyComponent(
                    businessSpecialtyList: [
                      SelectSpecialty(
                        name: 'name',
                        description: 'description',
                        isSelected: true,
                      ),
                      SelectSpecialty(
                        name: 'name',
                        description: 'description',
                        isSelected: false,
                      ),
                      SelectSpecialty(
                        name: 'name',
                        description: 'description',
                        isSelected: true,
                      ),
                    ],
                    leisureSpecialtyList: [
                      SelectSpecialty(
                        name: 'name',
                        description: 'description',
                        isSelected: false,
                      ),
                      SelectSpecialty(
                        name: 'name',
                        description: 'description',
                        isSelected: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            OrdinaryButton(
              text: 'To become an influencer you need to do:',
              onPressed: () => showGeneralDialog(
                context: context,
                transitionBuilder: (context, animation1, animation2, child) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: animation1.value * 30, sigmaY: animation1.value * 30),
                  child: child,
                ),
                pageBuilder: (context, animation1, animation2) => FadeTransition(
                  opacity: animation1,
                  child: const ProgressBecomingInfluencerComponent(
                    reviewsProgress: 47,
                    videoReactionProgress: 50,
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            OrdinaryButton(
              text: 'show new tool component',
              onPressed: () => showUiKitGeneralFullScreenDialog(
                context,
                GeneralDialogData(
                  useRootNavigator: false,
                  child: InfluencerToolsComponent(
                    onTap: () {},
                    influencerUiModelList: [
                      InfluencerToolUiModel(
                        title: S.of(context).CountReviews(''),
                        progress: 100,
                        actualProgress: 50,
                      ),
                      InfluencerToolUiModel(
                        title: S.of(context).CountVideoReaction(''),
                        progress: 100,
                        actualProgress: 50,
                      ),
                      InfluencerToolUiModel(
                        title: S.of(context).News,
                        progress: 50,
                        actualProgress: 0,
                      ),
                      InfluencerToolUiModel(
                        title: S.of(context).Voices,
                        progress: 50,
                        actualProgress: 0,
                      ),
                      InfluencerToolUiModel(
                        title: S.of(context).Photos,
                        progress: 50,
                        actualProgress: 0,
                      ),
                      InfluencerToolUiModel(
                        title: S.of(context).IdealRoute,
                        progress: 5,
                        actualProgress: 0,
                      ),
                    ],
                    newToolsInfluncerList: [
                      S.of(context).Photos,
                      S.of(context).Voices,
                      S.of(context).News,
                      S.of(context).IdealRoute,
                    ],
                  ),
                ),
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
