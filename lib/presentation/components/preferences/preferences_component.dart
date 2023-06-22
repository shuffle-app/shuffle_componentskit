import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PreferencesComponent extends StatelessWidget {
  final VoidCallback? onSubmit;
  final UiPreferencesModel preferences;
  final Function onSelect;
  final bool isLoading;

  PreferencesComponent(
      {Key? key,
      this.onSubmit,
      required this.preferences,
      this.isLoading = false,
      required this.onSelect})
      : super(key: key);

  final GlobalKey _myKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final subHeadline = context.uiKitTheme?.boldTextTheme.subHeadline;

    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentAboutUserModel model =
        ComponentAboutUserModel.fromJson(config['about_user']);
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin =
        (model.positionModel?.verticalMargin ?? 0).toDouble();

    return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tell us more\nabout yourself',
                style: context.uiKitTheme?.boldTextTheme.title1,
              ).paddingSymmetric(horizontal: horizontalMargin),
              SpacingFoundation.verticalSpace16,
              RichText(
                key: _myKey,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tap once to ',
                      style: subHeadline,
                    ),
                    TextSpan(
                      text: 'choose what you like',
                      style: subHeadline?.copyWith(
                          foreground: Paint()
                            ..shader = GradientFoundation.buttonGradient
                                .createShader(_myKey.currentContext
                                        ?.findRenderObject()
                                        ?.paintBounds ??
                                    Rect.zero)),
                    ),
                    TextSpan(
                      text: '. Tap twice to mark your favorites.',
                      style: subHeadline,
                    )
                  ],
                ),
              ).paddingSymmetric(horizontal: horizontalMargin),
              // SpacingFoundation.verticalSpace16,
              // SizedBox(
              //     width: double.infinity,
              //     child: UiKitInputFieldRightIcon(
              //       hintText: 'search'.toUpperCase(),
              //       controller: preferences.searchController,
              //       icon: preferences.searchController.text.isEmpty
              //           ? ImageWidget(
              //               svgAsset: GraphicsFoundation.instance.svg.search,
              //               color: Colors.white.withOpacity(0.5),
              //             )
              //           : null,
              //       // onPressed: () {
              //       //   if(preferences.searchController.text.isNotEmpty) preferences.searchController.clear();
              //       // },
              //     )).paddingSymmetric(horizontal: horizontalMargin),
              // SpacingFoundation.verticalSpace24,
              Expanded(
                child: LayoutBuilder(
                  builder: (context, size) {
                    print(size.maxHeight);

                    return Bubbles(
                      width: 1.sw,
                      height: size.maxHeight,
                      widgets: preferences.chips,
                    );
                  },
                ),
              ),
            ],
          ).paddingSymmetric(vertical: verticalMargin),
        ),
        bottomSheet: SafeArea(
          top: false,
          child: SizedBox(
                  width: double.infinity,
                  child: context
                      .button(
                          data: BaseUiKitButtonData(
                              text: 'start to explore'.toUpperCase(),
                              onPressed: onSubmit))
                      .loadingWrap(isLoading))
              .paddingSymmetric(horizontal: horizontalMargin, vertical: 20),
        ));
  }
}
