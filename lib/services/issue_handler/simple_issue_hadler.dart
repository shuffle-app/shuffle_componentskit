import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';

import 'navigation_service/navigation_key.dart';

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
