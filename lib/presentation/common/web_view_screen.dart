import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class WebViewScreen extends StatelessWidget {
  final String title;
  final String url;
  final bool showWebView;

  const WebViewScreen({super.key, required this.title, required this.url, this.showWebView = false});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(UiKitColors.surface);
    if (showWebView) {
      controller.loadRequest(Uri.parse(url));
    }

    return Scaffold(
      body: BlurredAppBarPage(
          physics: const NeverScrollableScrollPhysics(),
          autoImplyLeading: true,
          title: title,
          centerTitle: true,
          body: showWebView
              ? WebViewWidget(controller: controller)
              : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: WebContentComponent(
                url: url,
              ))),
    );
  }
}
