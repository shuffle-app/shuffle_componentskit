import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class WebViewScreen extends StatelessWidget {
  final String title;
  final String url;

  const WebViewScreen({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredAppBarPage(
          autoImplyLeading: true,
          title: title,
          body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: WebContentComponent(
            url: url,
          ))),
    );
  }
}
