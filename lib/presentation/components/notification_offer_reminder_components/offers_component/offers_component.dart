import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class OffersComponent extends StatelessWidget {
  final String? placeOrEventName;
  final List<UniversalNotOfferRemUiModel?>? listOffers;
  final ValueChanged<int?>? onEditOffer;
  final ValueChanged<int?>? onRemoveOffer;
  final VoidCallback? onCreateOffer;

  const OffersComponent({
    super.key,
    this.placeOrEventName,
    this.listOffers,
    this.onEditOffer,
    this.onCreateOffer,
    this.onRemoveOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UniversalFormForNotOfferRem(
        title: S.of(context).Offers,
        itemList: listOffers,
        nameForEmptyList: placeOrEventName,
        onCreateItem: onCreateOffer,
        onEditItem: onEditOffer,
        onRemoveItem: onRemoveOffer,
        whatCreate: S.of(context).Offer,
      ),
    );
  }
}
