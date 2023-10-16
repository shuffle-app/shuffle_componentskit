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
    final randomNumber = Random().nextInt(4) + 1;
    if (randomNumber == 1) {
      return GraphicsFoundation.instance.png.mockAdBanner1.path;
    } else if (randomNumber == 2) {
      return GraphicsFoundation.instance.png.mockAdBanner2.path;
    } else if (randomNumber == 3) {
      return GraphicsFoundation.instance.png.mockAdBanner3.path;
    } else if (randomNumber == 4) {
      return GraphicsFoundation.instance.png.mockAdBanner4.path;
    } else if (randomNumber == 5) {
      return GraphicsFoundation.instance.png.mockAdBanner5.path;
    } else {
      return GraphicsFoundation.instance.png.mockAdBanner1.path;
    }
  }
}
