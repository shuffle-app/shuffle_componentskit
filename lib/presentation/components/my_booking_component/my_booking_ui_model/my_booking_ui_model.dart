class MyBookingUiModel {
  final int id;
  final String? name;
  final int? ticket;
  final int? product;
  final int? total;
  final String? currency;
  final bool isPast;

  MyBookingUiModel({
    required this.id,
    this.name,
    this.ticket,
    this.product,
    this.total,
    this.currency,
    this.isPast = false,
  });
}
