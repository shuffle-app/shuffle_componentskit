import 'package:shuffle_components_kit/shuffle_components_kit.dart';

catchWidgetError(error,stackTrace){
  try {
    SnackBarUtils.show(
        message: 'got widget build error ${error.toString()}', context: navigatorKey.currentState!.context);
  } catch (e) {

  }
}