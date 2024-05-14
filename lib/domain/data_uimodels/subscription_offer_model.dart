import 'package:shuffle_components_kit/presentation/utils/extentions/number_converters.dart';

class SubscriptionOfferModel {
  final String name;
  final double price;
  final String currency;
  final String periodName;
  final int? savings;
  final String storePurchaseId;

  String get formattedPriceWithPeriod => '$currency${price.nanOrTwoTrailingZeros}/$periodName';

  String get formattedPriceNoPeriod => '$currency${price.nanOrTwoTrailingZeros}';

  SubscriptionOfferModel({
    this.savings,
    required this.storePurchaseId,
    required this.name,
    required this.price,
    required this.currency,
    required this.periodName,
  });
}
