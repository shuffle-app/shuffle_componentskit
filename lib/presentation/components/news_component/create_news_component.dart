import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CreateNewsComponent extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onCreateTap;

  const CreateNewsComponent({
    super.key,
    required this.controller,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: context
            .gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).Create.toUpperCase(),
                onPressed: onCreateTap,
              ),
            )
            .paddingOnly(
              bottom: SpacingFoundation.verticalSpacing16,
              right: SpacingFoundation.horizontalSpacing16,
              left: SpacingFoundation.horizontalSpacing16,
            ),
      ),
      body: BlurredAppBarPage(
        title: S.of(context).CreateNews,
        centerTitle: true,
        autoImplyLeading: true,
        children: [
          UiKitCardWrapper(
            color: theme?.colorScheme.surface1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpacingFoundation.verticalSpace4,
                Text(
                  S.of(context).WhatsNew,
                  style: theme?.boldTextTheme.labelLarge,
                ).paddingOnly(left: SpacingFoundation.horizontalSpacing12),
                SpacingFoundation.verticalSpace4,
                UiKitSymbolsCounterInputField(
                  controller: controller,
                  enabled: true,
                  obscureText: false,
                  hintText: S.current.DescribeYourIssue.toUpperCase(),
                  showSymbols: false,
                ).paddingAll(EdgeInsetsFoundation.all4),
              ],
            ),
          ).paddingAll(EdgeInsetsFoundation.all16)
        ],
      ),
    );
  }
}
