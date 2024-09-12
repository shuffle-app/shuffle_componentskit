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
  DateTime? selectedDateTime;
  bool showSabsInContentCard;

  BookingUiModel({
    required this.id,
    this.price,
    this.currency,
    this.bookingLimit,
    this.bookingLimitPerOne,
    this.subsUiModel,
    this.upsaleUiModel,
    this.selectedDateTime,
    this.showSabsInContentCard = false,
  });

  BookingUiModel copyWith({
    int? id,
    String? price,
    String? currency,
    String? bookingLimit,
    String? bookingLimitPerOne,
    List<SubsUiModel>? subsUiModel,
    List<UpsaleUiModel>? upsaleUiModel,
    DateTime? selectedDateTime,
  }) {
    return BookingUiModel(
      id: id ?? this.id,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      bookingLimit: bookingLimit ?? this.bookingLimit,
      bookingLimitPerOne: bookingLimitPerOne ?? this.bookingLimitPerOne,
      subsUiModel: subsUiModel ?? this.subsUiModel,
      upsaleUiModel: upsaleUiModel ?? this.upsaleUiModel,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
    );
  }

  String? validateCreation({bool checkDate = false}) {
    if (bookingLimit == null || bookingLimit!.isEmpty || bookingLimit == '0') {
      return S.current.XIsRequired(S.current.BookingLimit);
    } else if (selectedDateTime == null && checkDate) {
      return S.current.XIsRequired(S.current.Date);
    }

    return null;
  }

  BookingUiModel.empty()
      : id = -1,
        bookingLimit = '',
        bookingLimitPerOne = '',
        currency = 'AED',
        price = '',
        selectedDateTime = null,
        showSabsInContentCard = false,
        subsUiModel = List.empty(growable: true),
        upsaleUiModel = List.empty(growable: true);
}
