import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class PromotionsComponent extends StatelessWidget {
  final String? placeOrEventName;
  final List<UniversalNotOfferRemUiModel?>? listPromotions;
  final ValueChanged<int?>? onEditPromotion;
  final ValueChanged<int?>? onRemovePromotion;
  final VoidCallback? onCreatePromotion;
  final GlobalKey<SliverAnimatedListState> listKey;

  const PromotionsComponent({
    super.key,
    required this.listKey,
    this.placeOrEventName,
    this.listPromotions,
    this.onEditPromotion,
    this.onRemovePromotion,
    this.onCreatePromotion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UniversalFormForNotOfferRem(
        animatedListKey: listKey,
        title: 'Promotions',
        itemList: listPromotions,
        nameForEmptyList: placeOrEventName,
        onCreateItem: onCreatePromotion,
        onEditItem: onEditPromotion,
        onRemoveItem: onRemovePromotion,
        whatCreate: 'Promotion',
        isPromotion: true,
      ),
    );
  }
}
