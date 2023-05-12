import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

ThemeData themeMatcher(String themeString) {
  switch (themeString) {
    case 'default':
      return UiKitThemeFoundation.defaultTheme;
    case 'fallbackTheme':
      return UiKitThemeFoundation.fallbackTheme;
    default:
      return ThemeData();
  }
}
