import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FAQComponent extends StatefulWidget {
  final Map<String, String> faqData;

  const FAQComponent({super.key, required this.faqData,});

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
        : widget.faqData.keys
            .where((element) => element.toLowerCase().contains(_controller.text.toLowerCase()))
            .toList();

    return Scaffold(
      body: BlurredAppBarPage(
        title: S.of(context).Faq.toUpperCase(),
        autoImplyLeading: true,
        appBarBody: itemsToShow.isEmpty
            ? null
            : SizedBox(
                width: double.infinity,
                child: UiKitInputFieldRightIcon(
                  hintText: S.of(context).Search.toUpperCase(),
                  controller: _controller,
                  fillColor: theme?.colorScheme.surface3,
                  icon: ImageWidget(
                    iconData: ShuffleUiKitIcons.search,
                    color: theme?.colorScheme.inversePrimary.withOpacity(0.5),
                  ),
                ),
              ),
        customToolbarHeight: itemsToShow.isEmpty ? null : 170.0,
        centerTitle: true,
        childrenPadding: EdgeInsets.symmetric(
          horizontal: SpacingFoundation.horizontalSpacing16,
        ),
        childrenBuilder: (context, index) {
          if (itemsToShow.isEmpty) {
            return const UnderDevelopment().paddingOnly(top: 0.3.sh);
          }

          return Theme(
            data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: theme?.textButtonStyle(theme.colorScheme.inversePrimary).copyWith(
                      padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                      textStyle: WidgetStateTextStyle.resolveWith(
                        (states) {
                          return theme.regularTextTheme.body;
                        },
                      ),
                    ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index == 0) SpacingFoundation.verticalSpace16,
                context.button(
                  reversed: true,
                  isTextButton: true,
                  data: BaseUiKitButtonData(
                    onPressed: () => showUiKitGeneralFullScreenDialog(
                      context,
                      GeneralDialogData(
                        child: WebContentComponent(url: widget.faqData[itemsToShow[index]]!).paddingSymmetric(
                            vertical: SpacingFoundation.verticalSpacing16,
                            horizontal: SpacingFoundation.horizontalSpacing16),
                      ),
                    ),
                    text: itemsToShow[index],
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.chevronright,
                      color: theme?.colorScheme.inversePrimary,
                    ),
                  ),
                ),
                Divider(color: theme?.colorScheme.darkNeutral600)
                    .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16),
              ],
            ),
          );
        },
        childrenCount: itemsToShow.isEmpty ? 1 : itemsToShow.length,
      ),
    );
  }
}
