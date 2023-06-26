import 'package:flutter/material.dart';

// import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchResultComponent extends StatelessWidget {
  final Widget resultBody;
  final String heroSearchTag;
  final String? errorText;
  final FocusNode? searchFieldFocus;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController searchController;

  const SearchResultComponent(
      {super.key,
      required this.resultBody,
      required this.heroSearchTag,
      required this.searchController,
      this.onFieldSubmitted,
      this.searchFieldFocus,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return BlurredAppBarPage(
        title: 'You’ll find it',
        wrapSliverBox: false,
        centerTitle: true,
        autoImplyLeading: true,
        topFixedAddition: Hero(
            tag: heroSearchTag,
            child: SizedBox(
                width: double.infinity,
                child: UiKitInputFieldRightIcon(
                  // focusNode: searchFieldFocus,
                  autofocus: true,
                  hintText: 'search'.toUpperCase(),
                  controller: searchController,
                  errorText: errorText,
                  icon: searchController.text.isEmpty
                      ? ImageWidget(
                          svgAsset: GraphicsFoundation.instance.svg.search,
                          color: Colors.white.withOpacity(0.5))
                      : null,
                  onPressed: () {
                    searchController.clear();
                    print('clooose!');
                    context.pop();
                  },
                  onFieldSubmitted: onFieldSubmitted,
                ))).paddingOnly(top: SpacingFoundation.verticalSpacing24),
        body: GestureDetector(
            onTap: () {
              if (searchController.text.isEmpty) {
                FocusManager.instance.primaryFocus?.unfocus();
                context.pop();
              }
            },
            child: SingleChildScrollView(child: resultBody)));
  }
}
