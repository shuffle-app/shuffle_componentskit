import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
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
                  ? GlobalComponent(
                      globalConfiguration: configuration,
                      child: ComponentsTestPage())
                  : Builder(builder: (c) {
                      configuration
                          .load(version: '1.0.2')
                          .then(
                              (_) => Future.delayed(const Duration(seconds: 1)))
                          .then((_) => UiKitTheme.of(c).onThemeUpdated(
                              themeMatcher(configuration.appConfig.theme)));
                      return const Scaffold(
                          body: Center(child: LoadingWidget()));
                    }),
              // onGenerateRoute: AppRouter.onGenerateRoute,
              // initialRoute: AppRoutes.initial,
            )));
      },
    );
  }
}

class ComponentsTestPage extends StatelessWidget {
  ComponentsTestPage({Key? key}) : super(key: key);

  final GlobalConfiguration configuration = GlobalConfiguration();

  @override
  Widget build(BuildContext context) {
    final UiEventModel event = UiEventModel(
      id: 1,
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
      descriptionItems: const [
        UiDescriptionItemModel(
          title: 'Don\'t miss out',
          description: 'Burj Khalifa 122nd Floor',
        ),
        UiDescriptionItemModel(
          title: 'Open now',
          description: '9:30 am - 10:30 pm',
        ),
      ],
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
                    text: 'show onboarding',
                    onPressed: () => buildComponent(
                        context,
                        ComponentModel.fromJson(
                            configuration.appConfig.content['onboarding']),
                        ComponentBuilder(
                            child: Scaffold(body: OnboardingComponent()))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show about user step 1',
                    onPressed: () => buildComponent(
                        context,
                        ComponentModel.fromJson(
                            configuration.appConfig.content['about_user']),
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
                        ComponentShuffleModel.fromJson(
                            configuration.appConfig.content['about_user']),
                        ComponentBuilder(
                            child: Scaffold(
                                body: PreferencesComponent(
                          preferences: UiPreferencesModel([
                            UiKitImportanceChip(
                                title: 'Electronic\nMusic',
                                importance: ImportanceChip.high),
                            UiKitImportanceChip(
                                title: 'Swimming',
                                importance: ImportanceChip.medium),
                            UiKitImportanceChip(
                                title: 'Theme\nParks',
                                importance: ImportanceChip.none),
                            UiKitImportanceChip(
                                title: 'Hookah',
                                importance: ImportanceChip.high),
                            UiKitImportanceChip(
                                title: 'Electronic\nMusic',
                                importance: ImportanceChip.high),
                            UiKitImportanceChip(
                                title: 'Swimming',
                                importance: ImportanceChip.medium),
                            UiKitImportanceChip(
                                title: 'Theme\nParks',
                                importance: ImportanceChip.none),
                            UiKitImportanceChip(
                                title: 'Hookah',
                                importance: ImportanceChip.high),
                            UiKitImportanceChip(
                                title: 'Electronic\nMusic',
                                importance: ImportanceChip.high),
                            UiKitImportanceChip(
                                title: 'Swimming',
                                importance: ImportanceChip.medium),
                            UiKitImportanceChip(
                                title: 'Theme\nParks',
                                importance: ImportanceChip.none),
                            UiKitImportanceChip(
                                title: 'Hookah',
                                importance: ImportanceChip.high),
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
                        ComponentShuffleModel.fromJson(
                            configuration.appConfig.content['profile']),
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
                              interests: [
                                'Restaurants',
                                'Hookah',
                                'Roller Coaster',
                                'Swimmings'
                              ],
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
                        ComponentShuffleModel.fromJson(
                            configuration.appConfig.content['shuffle']),
                        ComponentBuilder(
                            child: Scaffold(
                                body: ShuffleComponent(
                          shuffle: UiShuffleModel(
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
                                    customSpace:
                                        SpacingFoundation.horizontalSpace8,
                                    showSpacing: true,
                                  ),
                                  UiKitTagWidget(
                                    title: 'Club',
                                    icon: Assets.images.svg.cocktail.path,
                                    customSpace:
                                        SpacingFoundation.horizontalSpace8,
                                    showSpacing: true,
                                  ),
                                  UiKitTagWidget(
                                    title: 'Club',
                                    icon: Assets.images.svg.cocktail.path,
                                    customSpace:
                                        SpacingFoundation.horizontalSpace8,
                                    showSpacing: true,
                                  ),
                                  UiKitTagWidget(
                                    title: 'Club',
                                    icon: Assets.images.svg.cocktail.path,
                                    customSpace:
                                        SpacingFoundation.horizontalSpace8,
                                    showSpacing: true,
                                  ),
                                ]),
                          )),
                        )))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show spinner',
                    onPressed: () => buildComponent(
                        context,
                        ComponentSpinnerModel.fromJson(
                            configuration.appConfig.content['spinner']),
                        ComponentBuilder(
                            child: Scaffold(
                                body: SpinnerComponent(
                                    onEventTap: () {},
                                    onFavoriteTap: () {},
                                    spinner: UiSpinnerModel(
                                        categories: List<String>.generate(
                                          10,
                                          (index) => 'Category ${index + 1}',
                                        ),
                                        events: List.generate(
                                            5, (index) => event)))))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show feed',
                    onPressed: () => buildComponent(
                        context,
                        ComponentFeedModel.fromJson(
                            configuration.appConfig.content['feed']),
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
                                        controller:
                                            PagingController(firstPageKey: 1),
                                        feed: UiFeedModel(
                                          // mixedItems: List.generate(4, (index) => item),
                                          recommendedEvent: event,
                                          moods: List.generate(
                                              4,
                                              (index) => UiMoodModel(
                                                  id: 1,
                                                  title:
                                                      'Want to have some fun',
                                                  logo:
                                                      'assets/images/png/crazy_emoji.png')),
                                        )))))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show mood',
                    onPressed: () => buildComponent(
                        context,
                        ComponentMoodModel.fromJson(
                            configuration.appConfig.content['mood']),
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
                                      const UiDescriptionItemModel(
                                          active: true,
                                          title: 'Sunny',
                                          description: '+32'),
                                      const UiDescriptionItemModel(
                                          active: true,
                                          title: 'Burned today',
                                          description: '432'),
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
                        ComponentPlaceModel.fromJson(
                            configuration.appConfig.content['place']),
                        ComponentBuilder(
                            child: PlaceComponent(place: place),
                            bottomBar: BottomBookingBar(
                                model: ComponentPlaceModel.fromJson(
                                            configuration
                                                .appConfig.content['place'])
                                        .bookingElementModel ??
                                    BookingElementModel(version: '0')))))),
            SpacingFoundation.verticalSpace16,
            context.button(
                data: BaseUiKitButtonData(
                    text: 'show event',
                    onPressed: () => buildComponent(
                        context,
                        ComponentEventModel.fromJson(
                            configuration.appConfig.content['event']),
                        ComponentBuilder(
                            child: EventComponent(event: event),
                            bottomBar: BottomBookingBar(
                                model: ComponentPlaceModel.fromJson(
                                            configuration
                                                .appConfig.content['event'])
                                        .bookingElementModel ??
                                    BookingElementModel(version: '0')))))),
            SpacingFoundation.verticalSpace16,
          ],
        ),
      ),
    );
  }

  final List<UiKitTag> tags = [
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: false),
    UiKitTag(
        title: 'Cheap',
        iconPath: 'assets/images/svg/cocktail.svg',
        unique: true),
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
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'uniqueCheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
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
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'uniqueCheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: false),
        UiKitTag(
            title: 'Cheap',
            iconPath: 'assets/images/svg/cocktail.svg',
            unique: true),
      ],
      descriptionItems: [
        const UiDescriptionItemModel(
            title: 'test 1',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
        const UiDescriptionItemModel(
            title: 'test 2',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
        const UiDescriptionItemModel(
            title: 'test 3',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
        const UiDescriptionItemModel(
            title: 'test 4',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '),
      ]);
}
