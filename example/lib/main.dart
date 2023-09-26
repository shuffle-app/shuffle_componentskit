import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalConfiguration configuration = GlobalConfiguration();
  ThemeData? _theme;

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
            child: WidgetsFactory(
                child: MaterialApp(
              title: 'Shuffle Demo',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: _theme ?? UiKitThemeFoundation.defaultTheme,
              //TODO: think about it
              home: configuration.isLoaded
                  ? GlobalComponent(globalConfiguration: configuration, child: ComponentsTestPage())
                  : Builder(builder: (c) {
                      configuration
                          .load(version: '1.0.1')
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
  ComponentsTestPage({Key? key}) : super(key: key);

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
      date: DateTime.now(),
      time: TimeOfDay.now(),
      timeTo: const TimeOfDay(hour: 15, minute: 59),

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
                          moods: List.generate(
                            4,
                            (index) => UiMoodModel(
                              id: 1,
                              title: 'Want to have some fun',
                              logo: 'assets/images/png/crazy_emoji.png',
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
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                              ],
                              tags: [
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Duh',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Metal',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Heavy',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Club',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheaper',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
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
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: false,
                                ),
                              ],
                              tags: [
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheap',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Duh',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Metal',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Heavy',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Club',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                                  unique: true,
                                ),
                                UiKitTag(
                                  title: 'Cheaper',
                                  iconPath: GraphicsFoundation.instance.svg.cutlery.path,
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
                text: 'show invite to event',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(configuration.appConfig.content['invite_people_places']),
                  ComponentBuilder(
                    child: InviteToFavouritePlacesComponent(
                      places: List<UiKitLeadingRadioTile>.generate(
                        10,
                        (index) => UiKitLeadingRadioTile(
                          title: 'title',
                          avatarLink: GraphicsFoundation.instance.png.inviteMock1.path,
                          tags: [
                            UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                            UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                            UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                            UiKitTag(title: 'title', iconPath: GraphicsFoundation.instance.svg.cocktail.path),
                          ],
                        ),
                      ),
                      uiModel: UiInviteToFavouritePlacesModel(
                        date: DateTime.now(),
                      ),
                      onInvite: () {},
                      onDatePressed: () {},
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
                      context.push(Scaffold(
                          body: CreateEventComponent(
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
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: false,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: false,
                            ),
                          ],
                          tags: [
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Cheap',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Duh',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Metal',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Heavy',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Club',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
                              unique: true,
                            ),
                            UiKitTag(
                              title: 'Cheaper',
                              iconPath: GraphicsFoundation.instance.svg.cutlery.path,
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
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show about user step 1',
                    onPressed: () => buildComponent(
                        context,
                        ComponentModel.fromJson(configuration.appConfig.content['about_user']),
                        ComponentBuilder(
                            child: Scaffold(
                          body: SafeArea(
                            child: SingleChildScrollView(
                                child: AboutUserComponent(
                              nameController: TextEditingController(),
                              nickNameController: TextEditingController(),
                              aboutUserModel: UiAboutUserModel(),
                            )),
                          ),
                        ))))),
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
                            UiKitImportanceChip(title: 'Electronic\nMusic', importance: ImportanceChip.high),
                            UiKitImportanceChip(title: 'Swimming', importance: ImportanceChip.medium),
                            UiKitImportanceChip(title: 'Theme\nParks', importance: ImportanceChip.none),
                            UiKitImportanceChip(title: 'Hookah', importance: ImportanceChip.high),
                            UiKitImportanceChip(title: 'Electronic\nMusic', importance: ImportanceChip.high),
                            UiKitImportanceChip(title: 'Swimming', importance: ImportanceChip.medium),
                            UiKitImportanceChip(title: 'Theme\nParks', importance: ImportanceChip.none),
                            UiKitImportanceChip(title: 'Hookah', importance: ImportanceChip.high),
                            UiKitImportanceChip(title: 'Electronic\nMusic', importance: ImportanceChip.high),
                            UiKitImportanceChip(title: 'Swimming', importance: ImportanceChip.medium),
                            UiKitImportanceChip(title: 'Theme\nParks', importance: ImportanceChip.none),
                            UiKitImportanceChip(title: 'Hookah', importance: ImportanceChip.high),
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
                          body: BlurredAppBarPage(
                            title: 'My card',
                            centerTitle: true,
                            body: ProfileComponent(
                                profile: UiProfileModel(
                              name: 'Marry Williams',
                              nickname: '@marywill',
                              description:
                                  'Just walking here and there trying to find something unique and interesting to show you!',
                              avatarUrl: 'assets/images/png/profile_avatar.png',
                              interests: ['Restaurants', 'Hookah', 'Roller Coaster', 'Swimmings'],
                              // followers: 2650,
                            )),
                          ),
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
                              title: 'Dance Again',
                              subtitle: 'Unique place for unique people',
                              imageLink: index == 0
                                  ? 'https://www.vipbeachclubbali.com/wp-content/uploads/2019/05/FINNS-12.jpg'
                                  : index == 1
                                      ? 'https://www.trutravels.com/blog/finns-beach-club.png'
                                      : 'https://media.cntraveler.com/photos/59f0e2c6b222cd1c857a0c8a/master/w_1200',
                              tags: [
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: Assets.images.svg.cocktail.path,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: Assets.images.svg.cocktail.path,
                                  customSpace: SpacingFoundation.horizontalSpace8,
                                  showSpacing: true,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: Assets.images.svg.cocktail.path,
                                  customSpace: SpacingFoundation.horizontalSpace8,
                                  showSpacing: true,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: Assets.images.svg.cocktail.path,
                                  customSpace: SpacingFoundation.horizontalSpace8,
                                  showSpacing: true,
                                ),
                                UiKitTagWidget(
                                  title: 'Club',
                                  icon: Assets.images.svg.cocktail.path,
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
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show feed',
                    onPressed: () => buildComponent(
                        context,
                        ComponentFeedModel.fromJson(configuration.appConfig.content['feed']),
                        ComponentBuilder(
                            child: Scaffold(
                                // appBar: AppBar(
                                //   backgroundColor: Colors.transparent,
                                //   toolbarHeight: 0,
                                //   bottomOpacity: 0,
                                //   toolbarOpacity: 0,
                                // ),
                                body: SingleChildScrollView(
                                    child: FeedComponent(
                                        showBusinessContent: false,
                                        controller: PagingController(firstPageKey: 1),
                                        feed: UiFeedModel(
                                          // mixedItems: List.generate(4, (index) => item),
                                          recommendedEvent: event,
                                          moods: List.generate(
                                              4,
                                              (index) => UiMoodModel(
                                                  id: 1,
                                                  title: 'Want to have some fun',
                                                  logo: 'assets/images/png/crazy_emoji.png')),
                                        )))))))),
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
                                  mood: UiMoodModel(
                                    descriptionItems: [
                                      const UiDescriptionItemModel(active: true, title: 'Sunny', description: '+32'),
                                      const UiDescriptionItemModel(
                                          active: true, title: 'Burned today', description: '432'),
                                    ],
                                    title: 'need to cool down a bit?',
                                    logo: 'assets/images/png/crazy_emoji.png',
                                    id: 1,
                                    places: List.generate(4, (index) => place),
                                  ),
                                ))))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show place',
                    onPressed: () => buildComponent(
                        context,
                        ComponentPlaceModel.fromJson(configuration.appConfig.content['place']),
                        ComponentBuilder(
                            child: PlaceComponent(place: place),
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
                            child: EventComponent(event: event),
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
                      onUserTypeSelected: (userType) => print(userType),
                      uiModel: UiUserTypeSelectionModel(
                        options: [],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
            context.button(
              data: BaseUiKitButtonData(
                text: 'show company registration',
                onPressed: () => buildComponent(
                  context,
                  ComponentModel.fromJson(configuration.appConfig.content['about_company']),
                  ComponentBuilder(
                    child: AboutCompanyComponent(
                      uiModel: UiAboutCompanyModel(),
                      nameController: TextEditingController(),
                      positionController: TextEditingController(),
                      formKey: GlobalKey<FormState>(),
                    ),
                  ),
                ),
              ),
            ),
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
              text: 'show complaint bottom sheet',
              onPressed: () => showUiKitGeneralFullScreenDialog(
                context,
                GeneralDialogData(
                  topPadding: 0.3.sh,
                  useRootNavigator: false,
                  child: ComplaintFormComponent(
                    onSend: () {},
                    nameController: TextEditingController(),
                    emailController: TextEditingController(),
                    issueController: TextEditingController(),
                    formKey: GlobalKey<FormState>(),
                  ),
                ),
              ),
            ),
            SpacingFoundation.verticalSpace16,
          ],
        ),
      ),
    );
  }

  final List<UiKitTag> tags = [
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
    UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
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
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
        UiKitTag(title: 'uniqueCheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
        UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
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
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
      UiKitTag(title: 'uniqueCheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: false),
      UiKitTag(title: 'Cheap', iconPath: 'assets/images/svg/cocktail.svg', unique: true),
    ],

    // descriptionItems: [
    //   const UiDescriptionItemModel(title: 'test 1', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    //   const UiDescriptionItemModel(title: 'test 2', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    //   const UiDescriptionItemModel(title: 'test 3', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    //   const UiDescriptionItemModel(title: 'test 4', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
    // ]
  );
}
