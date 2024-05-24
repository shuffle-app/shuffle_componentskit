import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class TagsSelectionComponent extends StatefulWidget {
  final PositionModel? positionModel;
  final List<String> selectedTags;
  final List<String> allTags;
  final String title;

  // final Future<List<String>> Function(String) options;

  const TagsSelectionComponent(
      {super.key, this.positionModel, required this.selectedTags, required this.title, required this.allTags});

  @override
  State<TagsSelectionComponent> createState() => _TagsSelectionComponentState();
}

class _TagsSelectionComponentState extends State<TagsSelectionComponent> {
  final Set<String> _tags = {};

  @override
  void initState() {
    _tags.addAll(widget.selectedTags);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.positionModel?.horizontalMargin?.toDouble() ?? 0;
    return Scaffold(
        bottomNavigationBar: _tags.isNotEmpty
            ? SafeArea(
                child: context.gradientButton(
                    data: BaseUiKitButtonData(
                        text: S.of(context).Save,
                        onPressed: () {
                          context.pop(result: _tags.toList());
                        })),
              )
            : null,
        body: BlurredAppBarPage(
            autoImplyLeading: true,
            centerTitle: true,
            title: widget.title,
            childrenPadding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            children: [
              SpacingFoundation.verticalSpace16,
              Wrap(
                spacing: SpacingFoundation.horizontalSpacing8,
                runSpacing: SpacingFoundation.verticalSpacing8,
                children: widget.allTags
                    .map<Widget>(
                      (e) => UiKitCompactTextCard(
                        showRemoveButton: _tags.contains(e),
                        showCheckedBackground: _tags.contains(e),
                        text: e,
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
              // SpacingFoundation.verticalSpace16,
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
