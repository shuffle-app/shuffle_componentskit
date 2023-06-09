import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart' as kit;

buildComponent(BuildContext context, UiBaseModel configuration,
    ComponentBuilder componentWidgets) {
  //TODO romancores: add later flavors
  if (kDebugMode) {
    SnackBarUtils.show(
        message: 'version ${configuration.version}', context: context);
  }
  switch (configuration.pageBuilderType) {
    case PageBuilderType.modalBottomSheet:
      return kit.showUiKitGeneralFullScreenDialog(
          context,
          kit.GeneralDialogData(
              child: componentWidgets.child,
              bottomBar: componentWidgets.bottomBar));

    case PageBuilderType.page:
      return context.push(componentWidgets.child);
    case PageBuilderType.dialog:
      return kit.showUiKitAlertDialog(
          context, componentWidgets.alertDialogData!);
  }
}

class ComponentBuilder {
  final Widget child;
  final Widget? bottomBar;
  final kit.AlertDialogData? alertDialogData;

  ComponentBuilder({required this.child, this.bottomBar, this.alertDialogData});
}
