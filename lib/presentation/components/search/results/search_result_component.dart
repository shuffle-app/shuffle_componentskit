import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchResultComponent extends StatelessWidget {
  final String heroSearchTag;
  final String? errorText;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onSearchValueChanged;
  final TextEditingController searchController;
  final bool autofocus;
  final FocusNode? searchFocusNode;
  final List<Widget> searchResults;
  final bool showSearchBar;
  final String? title;

  const SearchResultComponent({
    super.key,
    required this.heroSearchTag,
    required this.searchController,
    required this.searchResults,
    this.onFieldSubmitted,
    this.onSearchValueChanged,
    this.searchFocusNode,
    this.autofocus = true,
    this.showSearchBar = true,
    this.errorText,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // final config = GlobalConfiguration().appConfig.content;
    // final model = ComponentSearchModel.fromJson(config['search']);

    final colorScheme = context.uiKitTheme?.colorScheme;

    return BlurredAppBarPage(
      title: title ?? S.of(context).YoullFindIt,
      wrapSliverBox: false,
      centerTitle: true,
      autoImplyLeading: true,
      customToolbarHeight: 170.0,
      customToolbarBaseHeight: title != null ? 100 : null,
      canFoldAppBar: false,
      childrenPadding: EdgeInsets.only(bottom: EdgeInsetsFoundation.vertical16),
      appBarBody: showSearchBar
          ? UiKitInputFieldRightIcon(
              focusNode: searchFocusNode,
              autofocus: autofocus,
              fillColor: colorScheme?.surface3,
              hintText: S.of(context).Search.toUpperCase(),
              onChanged: onSearchValueChanged,
              controller: searchController,
              icon: searchController.text.isEmpty
                  ? ImageWidget(
                      iconData: ShuffleUiKitIcons.search,
                      color: colorScheme?.bodyTypography,
                    )
                  : null,
              onIconPressed: () {
                if (searchController.text.isNotEmpty) searchController.clear();
                // context.pop();
              },
              onFieldSubmitted: onFieldSubmitted,
            )
          : null,
      children: searchResults,
    );
  }
}
