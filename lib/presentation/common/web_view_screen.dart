import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String title;
  final String url;
  final bool showWebView;
  final NavigationDelegate? navigationDelegate;
  final bool useLightTheme;

  const WebViewScreen(
      {super.key,
      required this.title,
      required this.url,
      this.showWebView = false,
      this.navigationDelegate,
      this.useLightTheme = false});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent);
    if (showWebView) {
      controller.loadRequest(Uri.parse(url));
    }
    if (navigationDelegate != null) {
      controller.setNavigationDelegate(navigationDelegate!);
    }

    return Scaffold(
      body: BlurredAppBarPage(
        physics: const NeverScrollableScrollPhysics(),
        autoImplyLeading: true,
        title: title,
        centerTitle: true,
        children: [
          SizedBox.fromSize(
            size: Size(1.sw, 1.sh - MediaQuery.of(context).padding.top - kToolbarHeight - SpacingFoundation.verticalSpacing24),
            child: showWebView
                ? Stack(
                    children: [
                      const Positioned.fill(
                        top: -190.0,
                        child: LoadingWidget(),
                      ),
                      WebViewWidget(controller: controller),
                    ],
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: WebContentComponent(
                      url: url,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
