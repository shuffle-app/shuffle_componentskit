import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart' as kit;

buildComponent(BuildContext context, UiBaseModel configuration, Widget child,
    [Widget? bottomBar]) {
  //TODO romancores: add later flavors
  if (kDebugMode) {
    SnackBarUtils.show(
        message: 'version ${configuration.version}', context: context);
  }
  switch (configuration.pageBuilderType) {
    case PageBuilderType.modalBottomSheet:
      return kit.showUiKitGeneralFullScreenDialog(
          context, kit.GeneralDialogData(child: child, bottomBar: bottomBar));

    case PageBuilderType.page:
      return context.push(child);
  }
}
