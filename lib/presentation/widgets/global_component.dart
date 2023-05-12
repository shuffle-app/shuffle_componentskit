import 'package:flutter/cupertino.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class GlobalComponent extends InheritedWidget {
  static GlobalComponent? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<GlobalComponent>();
  final GlobalConfiguration globalConfiguration;

  const GlobalComponent({
    required this.globalConfiguration,
    required super.child,
    super.key,
  });

  // void updateGlobalConfiguration(GlobalConfiguration data) {
  //   onGlobalConfigurationUpdated(data);
  // }

  @override
  bool updateShouldNotify(covariant GlobalComponent oldWidget) => false;
}
