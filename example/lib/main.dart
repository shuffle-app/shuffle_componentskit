import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
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
                          .load()
                          .then((_) => Future.delayed(Duration(seconds: 1)))
                          .then((_) => UiKitTheme.of(c).onThemeUpdated(
                              themeMatcher(configuration.appConfig.theme)));
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
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
                text: 'show place',
                onPressed: () => buildComponent(
                    context,
                    PlaceModel.fromJson(
                        configuration.appConfig.content['place']),
                    PlaceComponent(
                      model: PlaceModel.fromJson(
                          configuration.appConfig.content['place']),
                      placeData: UiKitPlace(
                        media: [
                          UiKitMedia(
                              link: 'assets/images/png/place.png',
                              type: UiKitMediaType.video),
                          UiKitMedia(
                              link: 'assets/images/png/place.png',
                              type: UiKitMediaType.image),
                          UiKitMedia(
                              link: 'assets/images/png/place.png',
                              type: UiKitMediaType.image),
                          UiKitMedia(
                              link: 'assets/images/png/place.png',
                              type: UiKitMediaType.image),
                          UiKitMedia(
                              link: 'assets/images/png/place.png',
                              type: UiKitMediaType.image),
                        ],
                        description:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Sed euismod, nunc ut tincidunt lacinia, nisl nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
                            'Nulla facilisi. '
                            'Donec auctor, nisl eget aliquam tincidunt, nunc nisl aliquam nisl, vitae aliquam nisl nisl sit amet nunc. '
                            'Nulla facilisi',
                        rating: 4.8,
                        tags: [
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: false),
                          UiKitTag(
                              title: 'Cheap',
                              iconPath: 'assets/images/svg/cocktail.svg',
                              matching: true),
                        ],
                      ),
                      placeDescriptionItems: const [
                        PlaceDescriptionItem(
                          title: 'Address',
                          description: 'Burj Khalifa 122nd Floor',
                        ),
                        PlaceDescriptionItem(
                          title: 'Open now',
                          description: '9:30 am - 10:30 pm',
                        ),
                        PlaceDescriptionItem(
                          title: 'Website',
                          description: 'atmosphere.com',
                        ),
                        PlaceDescriptionItem(
                          title: 'Phone',
                          description: '+971123596943',
                        ),
                      ],
                    ),
                    BottomBookingBar(
                        model: PlaceModel.fromJson(
                            configuration.appConfig.content['place'])))),
            SpacingFoundation.verticalSpace16,
            context.button(
                text: 'show event',
                onPressed: () => buildComponent(
                    context,
                    EventModel.fromJson(
                        configuration.appConfig.content['event']),
                    Placeholder())),
            SpacingFoundation.verticalSpace16,
          ],
        ),
      ),
    );
  }
}
