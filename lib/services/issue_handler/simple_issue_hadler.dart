import '../../shuffle_components_kit.dart';

generalErrorCatch(error,stackTrace) {
  try {
    SnackBarUtils.show(
        message: 'got error ${error.toString()}', context: navigatorKey.currentState!.context);
  } catch (e) {
    SnackBarUtils.show(
        message: 'got stackTrace ${stackTrace.toString()}', context: navigatorKey.currentState!.context);

  }
  switch (error) {
    case NoSuchMethodError:
      break;
    case TypeError:
      break;
    default:
      throw error;
  }

}
