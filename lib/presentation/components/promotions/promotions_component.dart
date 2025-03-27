import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/localization/l10n.dart';

class PromotionsComponent extends StatelessWidget {
  final String? placeOrEventName;
  final String? placeOrEventImage;
  final List<UniversalNotOfferRemUiModel>? listPromotion;
  final ValueChanged<int?>? onEditPromo;
  final ValueChanged<int?>? onRemovePromo;
  final VoidCallback? onCreatePromo;
  final ValueChanged<int>? onActivateTap;
  final GlobalKey<SliverAnimatedListState> listKey;
  final ValueChanged<int>? onPayTap;

  /// Need for empty [listPromotion]
  final bool isPlace;
  final String? typeOfContent;


  const PromotionsComponent({
    super.key,
    required this.listKey,
    this.placeOrEventName,
    this.placeOrEventImage,
    this.listPromotion,
    this.onEditPromo,
    this.onRemovePromo,
    this.onCreatePromo,
    this.onActivateTap,
    this.isPlace = false,
    this.typeOfContent,
    this.onPayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UniversalFormForNotOfferRem(
        animatedListKey: listKey,
        title: S.of(context).Promotions,
        itemList: listPromotion,
        nameForEmptyList: placeOrEventName,
        onCreateItem: onCreatePromo,
        onEditItem: onEditPromo,
        onRemoveItem: onRemovePromo,
        onActivateTap: onActivateTap,
        showPopOver: false,
        customWhatCreate: S.of(context).CreateAPromotionForYourXAndIncreaseAttendance(
              '${isPlace ? S.of(context).PlacePromo.toLowerCase() : S.of(context).EventPromo.toLowerCase()} ${typeOfContent?.toLowerCase()} ${placeOrEventName}',
            ),
        onPayTap: onPayTap,
      ),
    );
  }
}
