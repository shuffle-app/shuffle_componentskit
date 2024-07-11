import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/hall_of_fame_component/show_model_viewer_dialog.dart';
import 'package:shuffle_uikit/ui_kit/atoms/profile/ui_reward_progress_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'animation_info.dart';

class HallOfFameComponent extends StatefulWidget {
  final List<UiKitAchievementsModel> items;
  final List<AnimationInfo> animations;
  final String? modelUrl;
  final String? posterUrl;

  const HallOfFameComponent(
      {super.key, required this.items, this.modelUrl, this.posterUrl, this.animations = const []});

  @override
  State<HallOfFameComponent> createState() => _HallOfFameComponentState();
}

class _HallOfFameComponentState extends State<HallOfFameComponent> with WidgetsBindingObserver {
  double? downloadProgress = 0;
  FileInfo? model;
  bool isLoading = false;
  bool animationInProgress = false;
  WebViewController? controller;
  late final JavascriptChannel _channel;
  final math.Random random = math.Random();

  Key? viewerKey = UniqueKey();

  @override
  void initState() {
    CustomCacheManager.personsInstance
        .getFileStream(widget.modelUrl ??
            'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/characters/1+character+(1).glb')
        .listen((value) {
      if (value.runtimeType == DownloadProgress) {
        setState(() {
          downloadProgress = (value as DownloadProgress).progress;
        });
      } else if (value.runtimeType == FileInfo) {
        Future.delayed(
            Duration.zero,
            () => setState(() {
                  model = value as FileInfo;
                  isLoading = false;
                }));
      }
    });
    _channel = JavascriptChannel('AnimationChannel', onMessageReceived: (JavaScriptMessage value) {
      log('message recieived: ${value.message}', name: 'HallOfFameComponent|AnimationChannel');
      Future.delayed(Duration(milliseconds: int.parse(value.message)), () {
        log('returning animation back', name: 'HallOfFameComponent|AnimationChannel');
        controller?.runJavaScript('''
                      var viewer = document.querySelector('#model-viewer');
                      viewer.setAttribute('animation-name', 'base');
                      ''');
        Future.delayed(
            Duration.zero,
            () => setState(() {
                  animationInProgress = false;
                }));
      });
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Future<bool> didPopRoute() {
    if (mounted) {
      setState(() {
        viewerKey = UniqueKey();
      });
    }
    return super.didPopRoute();
  }

  setAnimation() {
    if (animationInProgress) return;
    final animationItem = widget.animations[random.nextInt(widget.animations.length)];
    log('tapped ${animationItem.animationName}', name: 'HallOfFameComponent');
    controller?.runJavaScript('''
                    var viewer = document.querySelector('#model-viewer');
                    viewer.setAttribute('animation-name', '${animationItem.animationName}');
                    AnimationChannel.postMessage('${animationItem.durationInMs.round()}');
                    ''');
    setState(() {
      animationInProgress = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlurredAppBarPage(title: S.of(context).HallOfFame, autoImplyLeading: true, centerTitle: true, children: [
      SpacingFoundation.verticalSpace12,
      SizedBox(
          height: 0.394.sh,
          child: Stack(alignment: Alignment.bottomCenter, fit: StackFit.expand, children: [
            Positioned(
                top: 20.h,
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(1),
                  ])),
                  child: ImageWidget(
                      svgAsset: GraphicsFoundation.instance.svg.logo, height: 0.394.sh, fit: BoxFit.fitHeight),
                )),
            if (model != null)
              SizedBox(
                  height: 0.394.sh,
                  child: UiKitBase3DViewer(
                    key: viewerKey,
                    poster: widget.posterUrl ??
                        'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/posters/prince-2.png',
                    animationName: 'base',
                    localPath: model!.file.path,
                    autoPlay: true,
                    onTap: setAnimation,
                    javascriptChannels: {_channel},
                    // environmentImage: 'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/environments/6-ll.hdr',
                    onWebViewCreated: (WebViewController controller) {
                      setState(() {
                        this.controller = controller;
                      });
                      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
                      log('webview created with controller $controller', name: 'HallOfFameComponent');
                    },
                  ))
            else
              ImageWidget(
                link: widget.posterUrl ??
                    'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/posters/prince-2.png',
              ),
          ])),
      GridView.count(
        crossAxisCount: 3,
        addAutomaticKeepAlives: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: SpacingFoundation.horizontalSpacing16, vertical: SpacingFoundation.verticalSpacing16),
        childAspectRatio: 0.5.sp,
        crossAxisSpacing: SpacingFoundation.verticalSpacing8,
        children: widget.items
            .map((e) => GridTitledItemWidget(
                  preserveDarkTheme: true,
                  title: e.title,
                  child: UiKitFameItem(
                    uiModel: e,
                    preserveDarkTheme: true,
                    onTap: () => showModelViewerDialog(
                      context,
                      e,
                    ),
                  ),
                ))
            .toList(),
      ),
      kBottomNavigationBarHeight.heightBox
    ]);
  }
}
