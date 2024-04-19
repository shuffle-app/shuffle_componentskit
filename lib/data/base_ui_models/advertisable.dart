import 'dart:math';

import 'package:shuffle_uikit/shuffle_uikit.dart';

abstract class Advertisable {
  final bool isAdvertisement;
  late final String bannerPicture = _randomBannerPicture;

  Advertisable({
    required this.isAdvertisement,
  });

  String get _randomBannerPicture {
    // range from 1 to 5
    final randomNumber = Random().nextInt(9) + 1;
    switch (randomNumber) {
      case 1:
        return GraphicsFoundation.instance.png.mockAdBanner1.path;
      case 2:
        return GraphicsFoundation.instance.png.mockAdBanner2.path;
      case 3:
        return GraphicsFoundation.instance.png.mockAdBanner3.path;
      case 4:
        return GraphicsFoundation.instance.png.mockAdBanner4.path;
      case 5:
        return GraphicsFoundation.instance.png.mockAdBanner5.path;
      case 6:
        return GraphicsFoundation.instance.png.mockAdBanner6.path;
      case 7:
        return GraphicsFoundation.instance.png.mockAdBanner7.path;
      case 8:
        return GraphicsFoundation.instance.png.mockAdBanner8.path;
      case 9:
        return GraphicsFoundation.instance.png.mockAdBanner9.path;
      case 10:
        return GraphicsFoundation.instance.png.mockAdBanner10.path;
      case 11:
        return GraphicsFoundation.instance.png.mockAdBanner11.path;
      default:
        return GraphicsFoundation.instance.png.mockAdBanner1.path;
    }
  }
}
