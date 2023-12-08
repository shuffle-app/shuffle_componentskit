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

    return BlurredAppBarPage(
      title: S.of(context).YoullFindIt,
      wrapSliverBox: false,
      centerTitle: true,
      autoImplyLeading: true,
      customToolbarHeight: 160.0,
      canFoldAppBar: false,
      appBarBody: Hero(
        tag: heroSearchTag,
        child: SizedBox(
          width: double.infinity,
          child: UiKitInputFieldRightIcon(
            autofocus: autofocus,
            fillColor: ColorsFoundation.surface3,
            hintText: S.of(context).Search.toUpperCase(),
            controller: searchController,
            icon: searchController.text.isEmpty
                ? ImageWidget(iconData: ShuffleUiKitIcons.search, color: Colors.white.withOpacity(0.5))
                : null,
            onPressed: () {
              searchController.clear();
              // context.pop();
            },
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
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
            left: horizontalMargin,
            right: horizontalMargin,
          ),
        ),
      ],
    );
  }
}
