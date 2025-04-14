import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TagsSelectionComponent extends StatefulWidget {
  final PositionModel? positionModel;
  final List<UiKitTag> selectedTags;
  final List<UiKitTag> allTags;
  final String title;

  const TagsSelectionComponent({
    super.key,
    this.positionModel,
    required this.selectedTags,
    required this.title,
    required this.allTags,
  });

  @override
  State<TagsSelectionComponent> createState() => _TagsSelectionComponentState();
}

class _TagsSelectionComponentState extends State<TagsSelectionComponent> {
  final Set<UiKitTag> _tags = {};
  final Set<UiKitTag> _allTags = {};
  final TextEditingController _controller = TextEditingController();
  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  @override
  void initState() {
    _tags.addAll(widget.selectedTags);
    _allTags.addAll(widget.allTags);
    _controller.addListener(_checkEmpty);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.requestFocus();
    });
    super.initState();
  }

  _checkEmpty() {
    if (_controller.text.isEmpty) {
      setState(() {
        _allTags.addAll(widget.allTags);
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkEmpty);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
        widget.positionModel?.horizontalMargin?.toDouble() ?? SpacingFoundation.horizontalSpacing16;
    final theme = context.uiKitTheme;
    TextStyle? textStyle = theme?.boldTextTheme.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);
    return Scaffold(
        bottomNavigationBar: widget.selectedTags.isNotEmpty || _tags.isNotEmpty
            ? SafeArea(
                child: context
                    .gradientButton(
                        data: BaseUiKitButtonData(
                            text: S.of(context).Save,
                            onPressed: () {
                              context.pop(result: _tags.toList());
                            }))
                    .paddingSymmetric(horizontal: horizontalPadding),
              )
            : null,
        body: BlurredAppBarPage(
            autoImplyLeading: true,
            centerTitle: true,
            customToolbarBaseHeight: 100,
            customTitle: Flexible(
                child: AutoSizeText(
              widget.title,
              maxLines: 2,
              style: textStyle,
              wrapWords: false,
              textAlign: TextAlign.center,
            )),
            childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
            children: [
              SpacingFoundation.verticalSpace16,
              UiKitInputFieldRightIcon(
                controller: _controller,
                hintText: S.of(context).Search,
                onChanged: (value) {
                  setState(() {
                    _allTags.addAll(widget.allTags);
                    _allTags.retainWhere((e) => e.title.toLowerCase().contains(value.toLowerCase()));
                  });
                },
                icon: _controller.text.isEmpty
                    ? const ImageWidget(
                        iconData: Icons.search,
                      )
                    : null,
              ),
              SpacingFoundation.verticalSpace16,
              Wrap(
                spacing: SpacingFoundation.horizontalSpacing8,
                runSpacing: SpacingFoundation.verticalSpacing8,
                children: _allTags
                    .map<Widget>(
                      (e) => UiKitCompactTextCard(
                        showRemoveButton: _tags.contains(e),
                        showCheckedBackground: _tags.contains(e),
                        autoSizeGroup: autoSizeGroup,
                        text: e.title,
                        onTap: () {
                          setState(() {
                            if (!_tags.remove(e)) {
                              _tags.add(e);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              SpacingFoundation.verticalSpace16,
              MediaQuery.viewPaddingOf(context).bottom.heightBox
              // UiKitMultiSelectSuggestionField(
              //   initialOptions: _tags.toList(),
              //   borderRadius: BorderRadiusFoundation.all16,
              //   options: widget.options,
              //   onOptionSelected: (value) {
              //     setState(() {
              //       _tags.add(value);
              //     });
              //   },
              //   onOptionUnselected: (value) {
              //     setState(() {
              //       _tags.remove(value);
              //     });
              //   },
              // ),
              // 0.7.sh.heightBox
            ]));
  }
}
