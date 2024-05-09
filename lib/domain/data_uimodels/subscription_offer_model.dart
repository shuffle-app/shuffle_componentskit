class SubscriptionOfferModel {
  final String name;
  final double price;
  final String currency;
  final String periodName;
  final int? savings;
  final String storePurchaseId;

  String get formattedPriceWithPeriod => '$currency${price.toStringAsFixed(2)}/$periodName';

  String get formattedPriceNoPeriod => '$currency${price.toStringAsFixed(2)}';

  SubscriptionOfferModel({
    this.savings,
    required this.storePurchaseId,
    required this.name,
    required this.price,
    required this.currency,
    required this.periodName,
  });
}
