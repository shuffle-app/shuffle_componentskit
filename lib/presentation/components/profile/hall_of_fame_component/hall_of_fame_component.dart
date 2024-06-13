import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HallOfFameComponent extends StatefulWidget {
  final List<UiKitAchievementsModel> items;
  final String? modelUrl;
  final String? posterUrl;

  const HallOfFameComponent({super.key, required this.items, this.modelUrl, this.posterUrl});

  @override
  State<HallOfFameComponent> createState() => _HallOfFameComponentState();
}

class _HallOfFameComponentState extends State<HallOfFameComponent> {
  double? downloadProgress = 0;
  FileInfo? model;
  bool isLoading = false;
  WebViewController? controller;

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
        setState(() {
          model = value as FileInfo;
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    return BlurredAppBarPage(title: S.of(context).HallOfFame, autoImplyLeading: true, centerTitle: true, children: [
      SpacingFoundation.verticalSpace12,
      SizedBox(
          height: 0.394.sh,
          child: Stack(alignment: Alignment.bottomCenter, children: [
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

                    // javascriptChannels: {javascriptChannel},
                    // environmentImage: 'https://github.com/shuffle-app/test-images/raw/master/Interior%20Light%20HDRI.jpg',
                    // onWebViewCreated: (WebViewController controller) {
                    //   setState(() {
                    //     this.controller = controller;
                    //   });
                    //   controller.setJavaScriptMode(JavaScriptMode.unrestricted);
                    //   log('webview created with controller $controller', name: 'ModelViewerScreen');

                    //         this.controller?.runJavaScript('''
                    // var viewer = document.querySelector('#model-viewer');
                    // viewer.setAttribute('animation-name', '${animationsNames.first}');
                    // ''').onErrorNullable(cb: (error, st) {
                    //           log('error: $error', name: 'ModelViewerScreen');
                    //         });
                    // },
                  ))
            else
              ImageWidget(
                link: widget.posterUrl ??
                    'https://shuffle-app-production.s3.eu-west-2.amazonaws.com/static-files/3dmodels/posters/prince-2.png',
              )
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
                  title: e.title,
                  child: UiKitFameItem(
                    uiModel: e,
                  ),
                ))
            .toList(),
      ),
      kBottomNavigationBarHeight.heightBox
    ]);
  }
}
