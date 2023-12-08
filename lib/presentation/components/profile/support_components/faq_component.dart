import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

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
    //ignore: no-empty-block
    _controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    //ignore: no-empty-block
    _controller.removeListener(() => setState(() {}));
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    final itemsToShow = _controller.text.isEmpty
        ? widget.faqData.keys.toList()
        : widget.faqData.keys.where((element) => element.toLowerCase().contains(_controller.text.toLowerCase())).toList();
    // vertical: widget.positionModel?.verticalMargin?.toDouble() ?? 0,
    // horizontal: widget.positionModel?.horizontalMargin?.toDouble() ?? 0,
    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Faq.toUpperCase(),
        autoImplyLeading: true,
        appBarBody: SizedBox(
          width: double.infinity,
          child: UiKitInputFieldRightIcon(
            hintText: S.of(context).Search.toUpperCase(),
            controller: _controller,
            icon: ImageWidget(
              svgAsset: GraphicsFoundation.instance.svg.search,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),
        customToolbarHeight: 170.0,
        centerTitle: true,
        childrenPadding: EdgeInsets.symmetric(
          horizontal: widget.positionModel?.horizontalMargin?.toDouble() ?? 0,
        ),
        childrenBuilder: (context, index) {
          if (itemsToShow.isEmpty) {
            return Text(
              S.of(context).NothingFound.toUpperCase(),
              style: theme?.boldTextTheme.caption1Bold,
            );
          }

          return Theme(
            data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: context.uiKitTheme?.textButtonStyle().copyWith(
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                      textStyle: MaterialStateTextStyle.resolveWith(
                        (states) {
                          return context.uiKitTheme!.regularTextTheme.body;
                        },
                      ),
                    ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(index == 0) SpacingFoundation.verticalSpace16,
                context.button(
                  reversed: true,
                  isTextButton: true,
                  data: BaseUiKitButtonData(
                    onPressed: () => showUiKitGeneralFullScreenDialog(
                      context,
                      GeneralDialogData(
                        child: WebContentComponent(url: widget.faqData[itemsToShow[index]]!).paddingSymmetric(
                            vertical: widget.positionModel?.verticalMargin?.toDouble() ?? 0,
                            horizontal: widget.positionModel?.horizontalMargin?.toDouble() ?? 0),
                      ),
                    ),
                    text: itemsToShow[index],
                    icon: const ImageWidget(
                      iconData: ShuffleUiKitIcons.chevronright,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(color: UiKitColors.darkNeutral600).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16),
              ],
            ),
          );
        },
        childrenCount: itemsToShow.isEmpty ? 1 : itemsToShow.length,
      ),
    );
  }
}
