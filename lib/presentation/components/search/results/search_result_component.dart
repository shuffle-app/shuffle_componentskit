import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchResultComponent extends StatelessWidget {
  final Widget resultBody;
  final String heroSearchTag;
  final String? errorText;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController searchController;
  final bool autofocus;
  final ScrollController? scrollController;

  const SearchResultComponent({
    super.key,
    required this.resultBody,
    required this.heroSearchTag,
    required this.searchController,
    this.onFieldSubmitted,
    this.autofocus = true,
    this.scrollController,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final config = GlobalConfiguration().appConfig.content;
    final model = ComponentSearchModel.fromJson(config['search']);

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return BlurredAppBarPage(
      title: 'You’ll find it',
      wrapSliverBox: false,
      centerTitle: true,
      autoImplyLeading: true,
      customToolbarHeight: 150.0,
      appBarBody: Hero(
        tag: heroSearchTag,
        child: SizedBox(
          width: double.infinity,
          child: UiKitInputFieldRightIcon(
            autofocus: autofocus,
            fillColor: ColorsFoundation.surface3,
            hintText: 'search'.toUpperCase(),
            controller: searchController,
            errorText: errorText,
            icon: searchController.text.isEmpty
                ? ImageWidget(svgAsset: GraphicsFoundation.instance.svg.search, color: Colors.white.withOpacity(0.5))
                : null,
            onPressed: () {
              searchController.clear();
              context.pop();
            },
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (searchController.text.isEmpty) {
            FocusManager.instance.primaryFocus?.unfocus();
            context.pop();
          }
        },
        child: resultBody.paddingOnly(
          bottom: verticalMargin,
          left: horizontalMargin,
          right: horizontalMargin,
        ),
      ),
    );
  }
}
