import 'dart:developer';

import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WebContentComponent extends StatelessWidget {
  final String url;

  const WebContentComponent({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: get(Uri.parse(url)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          final response = snapshot.data as Response;
          log('get(Uri.parse(url) response: ${response.body}',name: 'WebContentComponent');

          return UiKitHtmlPresenter(htmlString: response.body);
        });
  }
}
