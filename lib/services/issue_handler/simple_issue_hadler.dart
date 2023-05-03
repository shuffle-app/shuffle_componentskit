import '../../shuffle_components_kit.dart';

generalErrorCatch(error,stackTrace) {
  try {
    SnackBarUtils.show(
        message: 'got error ${error.toString()}', context: navigatorKey.currentState!.context);
  } catch (e) {

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
