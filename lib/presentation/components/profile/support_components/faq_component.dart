import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class FAQComponent extends StatefulWidget {
  final Map<String, String> faqData;
  final PositionModel? positionModel;

  const FAQComponent({super.key, required this.faqData, this.positionModel});

  @override
  State<FAQComponent> createState() => _FAQComponentState();
}

class _FAQComponentState extends State<FAQComponent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(() => setState(() {}));
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    final itemsToShow = _controller.text.isEmpty
        ? widget.faqData.keys.toList()
        : widget.faqData.keys
        .where((element) =>
        element.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

    return Scaffold(body: BlurredAppBarPage(
        title: 'FAQ',
        autoImplyLeading: true,
        centerTitle: true,
        body: ListView.separated(
            padding: EdgeInsets.symmetric(
                vertical:
                widget.positionModel?.verticalMargin?.toDouble() ?? 0,
                horizontal:
                widget.positionModel?.horizontalMargin?.toDouble() ??
                    0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(
                    width: double.infinity,
                    child: UiKitInputFieldRightIcon(
                        hintText: 'search'.toUpperCase(),
                        controller: _controller,
                        icon: ImageWidget(
                            svgAsset:
                            GraphicsFoundation.instance.svg.search,
                            color: Colors.white.withOpacity(0.5))));
              }
              if (itemsToShow.isEmpty) {
                return Text(
                  'nothing found'.toUpperCase(),
                  style: theme?.boldTextTheme.caption1Bold,
                );
              }

              return Theme(
                  data: ThemeData(textButtonTheme: TextButtonThemeData(style:
                  context.uiKitTheme?.textButtonStyle.copyWith(
                    padding: MaterialStateProperty.all<EdgeInsets>( EdgeInsets.zero),
                      textStyle: MaterialStateTextStyle.resolveWith((states) {
                        return context.uiKitTheme!.regularTextTheme.body;
                      })))),
                  child: context.button(
                      reversed: true,
                      isTextButton: true,
                      data: BaseUiKitButtonData(
                          onPressed: () =>
                              showUiKitGeneralFullScreenDialog(
                                  context,
                                  GeneralDialogData(
                                      child: WebContentComponent(
                                          url: widget
                                              .faqData[itemsToShow[index -
                                              1]]!))),
                          text: itemsToShow[index - 1],
                          icon: ImageWidget(
                              svgAsset:
                              GraphicsFoundation.instance.svg.chevronRight,
                              color: Colors.white))));
            },
            separatorBuilder: (_, index) =>
            index == 0
                ? SpacingFoundation.verticalSpace24
                : const Divider(color: UiKitColors.darkNeutral600)
                .paddingSymmetric(
                vertical: SpacingFoundation.verticalSpacing16),
            itemCount: itemsToShow.isEmpty ? 2 : itemsToShow.length + 1)));
  }
}
