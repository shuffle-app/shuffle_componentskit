import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart' as kit;

Future buildComponent(BuildContext context, UiBaseModel configuration, ComponentBuilder componentWidgets) {
  //TODO romancores: add later flavors
  log(
    'Building ${configuration.pageBuilderType} v${configuration.version}',
    name: 'buildComponent',
  );
  // if (kDebugMode) {
  //   SnackBarUtils.show(
  //     message: 'version ${configuration.version}',
  //     context: context,
  //   );
  // }

  switch (configuration.pageBuilderType) {
    case PageBuilderType.modalBottomSheet:
      return kit.showUiKitGeneralFullScreenDialog(
        context,
        kit.GeneralDialogData(
          isWidgetScrollable: componentWidgets.isWidgetScrollable,
          child: componentWidgets.child,
          bottomBar: componentWidgets.bottomBar,
          useRootNavigator: componentWidgets.useRootNavigator,
          topPadding: componentWidgets.topPadding,
        ),
      );

    case PageBuilderType.page:
      return context.push(
        componentWidgets.child,
        useRootNavigator: componentWidgets.useRootNavigator,
        pageBuilder: componentWidgets.pageBuilder,
      );
    case PageBuilderType.dialog:
      return kit.showUiKitAlertDialog(context, componentWidgets.alertDialogData!);
  }
}

class ComponentBuilder {
  final Widget child;
  final Widget? bottomBar;
  final kit.AlertDialogData? alertDialogData;
  final bool useRootNavigator;
  late final bool isWidgetScrollable;
  double? topPadding;
  RoutePageBuilder? pageBuilder;

  ComponentBuilder({
    required this.child,
    this.bottomBar,
    this.alertDialogData,
    this.useRootNavigator = false,
    this.pageBuilder,
  }) {
    isWidgetScrollable = [
      PlaceComponent,
      EventComponent,
      Observer,
      NotificationsListComponent,
      AccountSubscriptionComponent,
      CompanySubscriptionComponent,
      AllReviewsComponent,
      FeedbackReaderComponent,
      AllVideoReactionsComponent
    ].contains(child.runtimeType);
  }
}
