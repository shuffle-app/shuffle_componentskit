import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchSocialFiltersSheetComponent extends StatefulWidget {
  final ContentBaseModel model;
  final ValueChanged<MapEntry<String, String>> onFilterChanged;
  final VoidCallback? onFiltersReset;
  final Map<String, String> selectedFilters;

  const SearchSocialFiltersSheetComponent({
    Key? key,
    required this.model,
    required this.onFilterChanged,
    required this.selectedFilters,
    this.onFiltersReset,
  }) : super(key: key);

  @override
  State<SearchSocialFiltersSheetComponent> createState() => _SearchSocialFiltersSheetComponentState();
}

class _SearchSocialFiltersSheetComponentState extends State<SearchSocialFiltersSheetComponent> {
  bool loading = true;
  Map<String, List<MapEntry<String, PropertiesBaseModel>>> mappedFilters = Map.identity();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterTitles = List<String>.from(
        widget.model.title?[ContentItemType.text]?.properties?.keys.map<String>((e) => e.toString()).toList() ?? [],
        growable: true,
      );

      final allFilterValues = widget.model.body?[ContentItemType.singleDropdown]?.properties?.entries.toList();

      for (final filter in filterTitles) {
        final filterValues = allFilterValues
                ?.where(
                  (element) => element.value.type?.toLowerCase() == filter.toLowerCase(),
                )
                .toList() ??
            [];
        filterValues.sort((a, b) => a.value.sortNumber!.compareTo(b.value.sortNumber!));
        if (mappedFilters.containsKey(filter)) {
          mappedFilters[filter]?.addAll(filterValues);
        } else {
          mappedFilters[filter] = List<MapEntry<String, PropertiesBaseModel>>.from(
            filterValues,
            growable: true,
          );
        }
      }

      setState(() => loading = false);
    });
  }

  String _valueTitle(String value) {
    if (value.isEmpty) return value;

    return widget.model.body?[ContentItemType.singleDropdown]?.properties?.entries
            .singleWhere((element) => element.value.value == value)
            .key ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final regularTextTheme = context.uiKitTheme?.regularTextTheme;

    if (loading) {
      return const SizedBox(
        height: 256,
        width: 256,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SpacingFoundation.verticalSpace16,
        Text(
          S.current.Filters,
          style: boldTextTheme?.subHeadline,
          textAlign: TextAlign.center,
        ),
        SpacingFoundation.verticalSpace16,
        GestureDetector(
          onTap: () {
            widget.onFiltersReset?.call();
            setState(() {});
          },
          child: Text(
            S.current.ResetFilters,
            style: boldTextTheme?.caption1Bold,
            textAlign: TextAlign.end,
          ),
        ),
        SpacingFoundation.verticalSpace16,
        ...mappedFilters.entries.map(
          (e) {
            final selectedValue = widget.selectedFilters[e.key] ?? '';
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  e.key,
                  style: regularTextTheme?.labelSmall,
                ),
                SpacingFoundation.verticalSpace4,
                UiKitMenu<String?>(
                  menuSheetHorizontalPadding: EdgeInsetsFoundation.zero,
                  title: e.key,
                  showBorder: false,
                  selectedItem: widget.selectedFilters[e.key] == null
                      ? null
                      : UiKitMenuItem(
                          title: _valueTitle(selectedValue),
                          value: selectedValue,
                        ),
                  onSelected: (option) {
                    widget.onFilterChanged(MapEntry(e.key, option.value ?? ''));
                    setState(() {});
                  },
                  items: e.value
                      .map<UiKitMenuItem<String>>(
                        (map) => UiKitMenuItem(
                          iconLink: map.value.imageLink,
                          iconColor: context.uiKitTheme?.colorScheme.inversePrimary,
                          title: map.key,
                          value: map.value.value,
                        ),
                      )
                      .toList(),
                ),
                SpacingFoundation.verticalSpace16,
              ],
            );
          },
        ),
      ],
    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16);
  }
}
