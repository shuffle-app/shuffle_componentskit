import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shuffle_components_kit/presentation/utils/ad_banner_lists.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

abstract class Advertisable {
  final bool isAdvertisement;
  late final UiKitSwiperAdCard largeTextBanner = _randomLargeTextBanner;
  late final String smallBannerImage = _randomSmallBannerPicture;
  late final String mediumBannerImage = _randomMediumBannerPicture;
  late final String largeBannerImage = _randomLargeBannerPicture;
  late final Widget smallTextBanner = _randomSmallTextAdBanner;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final AdvertisementBannerType bannerType;

  Advertisable({
    required this.isAdvertisement,
  }) {
    final chance = Random().nextDouble();
    if (chance < 0.25) {
      bannerType = AdvertisementBannerType.text;
    } else {
      bannerType = AdvertisementBannerType.picture;
    }
  }

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
    if (randomNumber == 1) return LargeTextAdBanner1(customHeight: (1.sh / 1.6) * 0.91);
    if (randomNumber == 2) return LargeTextAdBanner2(customHeight: (1.sh / 1.6) * 0.91);
    if (randomNumber == 3) return LargeTextAdBanner3(customHeight: (1.sh / 1.6) * 0.91);
    if (randomNumber == 4) return LargeTextAdBanner4(customHeight: (1.sh / 1.6) * 0.91);
    return LargeTextAdBanner1(customHeight: (1.sh / 1.6) * 0.91);
  }

  Widget get _randomSmallTextAdBanner {
    final randomNumber = Random().nextInt(4) + 1;
    if (randomNumber == 1) return const SmallTextAdBanner1();
    if (randomNumber == 2) return const SmallTextAdBanner2();
    if (randomNumber == 3) return const SmallTextAdBanner3();
    if (randomNumber == 4) return const SmallTextAdBanner4();
    if (randomNumber == 5) return const SmallTextAdBanner5();
    return const SmallTextAdBanner1();
  }

  String get _randomSmallBannerPicture {
    final randomIndex = Random().nextInt(smallBanners.length - 1);
    return smallBanners.elementAt(randomIndex);
  }

  String get _randomMediumBannerPicture {
    final randomIndex = Random().nextInt(mediumBanners.length - 1);
    return mediumBanners.elementAt(randomIndex);
  }

  String get _randomLargeBannerPicture {
    final randomIndex = Random().nextInt(largeBanners.length - 1);
    return largeBanners.elementAt(randomIndex);
  }
}

enum AdvertisementBannerType { picture, text }
