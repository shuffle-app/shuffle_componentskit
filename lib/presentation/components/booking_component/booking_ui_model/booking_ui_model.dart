import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'subs_or_upsale_ui_model.dart';

class BookingUiModel {
  int id;
  String? price;
  String? currency;
  String? bookingLimit;
  String? bookingLimitPerOne;
  List<SubsUiModel>? subsUiModel;
  List<UpsaleUiModel>? upsaleUiModel;

  BookingUiModel({
    required this.id,
    this.price,
    this.currency,
    this.bookingLimit,
    this.bookingLimitPerOne,
    this.subsUiModel,
    this.upsaleUiModel,
  });

  BookingUiModel copyWith({
    int? id,
    String? price,
    String? currency,
    String? bookingLimit,
    String? bookingLimitPerOne,
    List<SubsUiModel>? subsUiModel,
    List<UpsaleUiModel>? upsaleUiModel,
  }) {
    return BookingUiModel(
      id: id ?? this.id,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      bookingLimit: bookingLimit ?? this.bookingLimit,
      bookingLimitPerOne: bookingLimitPerOne ?? this.bookingLimitPerOne,
      subsUiModel: subsUiModel ?? this.subsUiModel,
      upsaleUiModel: upsaleUiModel ?? this.upsaleUiModel,
    );
  }

  String? validateCreation() {
    if (bookingLimit == null || bookingLimit!.isEmpty) {
      return S.current.XIsRequired(S.current.BookingLimit);
    } else if (bookingLimitPerOne == null || bookingLimitPerOne!.isEmpty) {
      return S.current.XIsRequired(S.current.BookingLimitPerOne);
    }

    return null;
  }
}