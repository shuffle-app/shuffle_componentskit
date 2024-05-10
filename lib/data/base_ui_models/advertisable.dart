import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

abstract class Advertisable {
  final bool isAdvertisement;
  late final String bannerPicture = _randomBannerPicture;
  late final UiKitSwiperAdCard largeTextBanner = _randomLargeTextBanner;
  late final Widget smallTextAdBanner = _randomSmallTextAdBanner;

  Advertisable({
    required this.isAdvertisement,
  });

  Widget spinnerTextBanner(double customHeight) {
    final randomNumber = Random().nextInt(3) + 1;
    if (randomNumber == 1) return MediumTextAdBanner1(customHeight: customHeight);
    if (randomNumber == 2) return MediumTextAdBanner2(customHeight: customHeight);
    if (randomNumber == 3) return MediumTextAdBanner3(customHeight: customHeight);
    if (randomNumber == 4) return MediumTextAdBanner4(customHeight: customHeight);
    return const SizedBox();
  }

  UiKitSwiperAdCard get _randomLargeTextBanner {
    final randomNumber = Random().nextInt(3) + 1;
    if (randomNumber == 1) return LargeTextAdBanner1(customHeight: (1.sh / 1.6) * 0.9);
    if (randomNumber == 2) return LargeTextAdBanner2(customHeight: (1.sh / 1.6) * 0.9);
    if (randomNumber == 3) return LargeTextAdBanner3(customHeight: (1.sh / 1.6) * 0.9);
    if (randomNumber == 4) return LargeTextAdBanner4(customHeight: (1.sh / 1.6) * 0.9);
    return LargeTextAdBanner1(customHeight: (1.sh / 1.6) * 0.9);
  }

  Widget get _randomSmallTextAdBanner {
    final randomNumber = Random().nextInt(3) + 1;
    if (randomNumber == 1) return const SmallTextAdBanner1();
    if (randomNumber == 2) return const SmallTextAdBanner2();
    if (randomNumber == 3) return const SmallTextAdBanner3();
    if (randomNumber == 4) return const SmallTextAdBanner4();
    return const SizedBox();
  }

  String get _randomBannerPicture {
    final randomNumber = Random().nextInt(16) + 1;
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
      case 12:
        return GraphicsFoundation.instance.png.mockAdBanner12.path;
      case 13:
        return GraphicsFoundation.instance.png.mockAdBanner13.path;
      case 14:
        return GraphicsFoundation.instance.png.mockAdBanner14.path;
      case 15:
        return GraphicsFoundation.instance.png.mockAdBanner15.path;
      case 16:
        return GraphicsFoundation.instance.png.mockAdBanner16.path;
      case 17:
        return GraphicsFoundation.instance.png.mockAdBanner17.path;
      default:
        return GraphicsFoundation.instance.png.mockAdBanner1.path;
    }
  }
}

enum AdvertisementBannerType { picture, text }
