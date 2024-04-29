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

  const SearchResultComponent({
    super.key,
    required this.resultBody,
    required this.heroSearchTag,
    required this.searchController,
    this.onFieldSubmitted,
    this.autofocus = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final config = GlobalConfiguration().appConfig.content;
    final model = ComponentSearchModel.fromJson(config['search']);

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final colorScheme = context.uiKitTheme?.colorScheme;

    return BlurredAppBarPage(
      title: S.of(context).YoullFindIt,
      wrapSliverBox: false,
      centerTitle: true,
      autoImplyLeading: true,
      customToolbarHeight: 170.0,
      canFoldAppBar: false,
      appBarBody: UiKitInputFieldRightIcon(
        autofocus: autofocus,
        fillColor: colorScheme?.surface3,
        hintText: S.of(context).Search.toUpperCase(),
        controller: searchController,
        icon: searchController.text.isEmpty
            ? ImageWidget(
                svgAsset: GraphicsFoundation.instance.svg.search,
                color: colorScheme?.bodyTypography,
              )
            : null,
        onIconPressed: () {
          if (searchController.text.isNotEmpty) searchController.clear();
          // context.pop();
        },
        onFieldSubmitted: onFieldSubmitted,
      ),
      children: [
        GestureDetector(
          onTap: () {
            if (searchController.text.isEmpty) {
              FocusManager.instance.primaryFocus?.unfocus();
              context.pop();
            }
          },
          child: resultBody.paddingOnly(
            bottom: verticalMargin,
          ),
        ),
      ],
    );
  }
}
