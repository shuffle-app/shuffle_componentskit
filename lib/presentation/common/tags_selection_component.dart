import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class TagsSelectionComponent extends StatefulWidget {
  final PositionModel? positionModel;
  final List<String> tags;
  final String title;
  final Future<List<String>> Function(String) options;

  const TagsSelectionComponent(
      {super.key, this.positionModel, required this.tags, required this.title, required this.options});

  @override
  State<TagsSelectionComponent> createState() => _TagsSelectionComponentState();
}

class _TagsSelectionComponentState extends State<TagsSelectionComponent> {
  final Set<String> _tags = {};

  @override
  void initState() {
    _tags.addAll(widget.tags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
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
        body: WillPopScope(
            onWillPop: () async {
              context.pop(result: _tags);
              return true;
            },
            child: BlurredAppBarPage(
                autoImplyLeading: true,
                centerTitle: true,
                title: widget.title,
                childrenPadding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                children: [
                  SpacingFoundation.verticalSpace16,
                  Wrap(
                    spacing: SpacingFoundation.horizontalSpacing8,
                    runSpacing: SpacingFoundation.verticalSpacing8,
                    children: _tags
                        .map<Widget>(
                          (e) =>
                          UiKitCompactTextCard(
                            showRemoveButton: true,
                            text: e,
                            onTap: () {
                              setState(() {
                                _tags.remove(e);
                              });
                            },
                          ),
                    )
                        .toList(),
                  ),
                  SpacingFoundation.verticalSpace16,
                  UiKitMultiSelectSuggestionField(
                    initialOptions: _tags.toList(),
                    borderRadius: BorderRadiusFoundation.all16,
                    options: widget.options,
                    onOptionSelected: (value) {
                      setState(() {
                        _tags.add(value);
                      });
                    },
                    onOptionUnselected: (value) {
                      setState(() {
                        _tags.remove(value);
                      });
                    },
                  ),
                  0.7.sh.heightBox
                ])));
  }
}
