import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'subs_ui_model.dart';

class BookingUiModel {
  int id;
  String? price;
  String? currency;
  String? bookingLimit;
  String? bookingLimitPerOne;
  List<SubsUiModel>? subsUiModel;
  List<UpsaleUiModel>? upsaleUiModel;
  DateTime? selectedDateTime;
  bool showSubsInContentCard;
  List<BookingPaymentType> selectedPaymentTypes;

  BookingUiModel({
    required this.id,
    this.price,
    this.currency,
    this.bookingLimit,
    this.bookingLimitPerOne,
    this.subsUiModel,
    this.upsaleUiModel,
    this.selectedDateTime,
    this.showSubsInContentCard = true,
    this.selectedPaymentTypes = const [BookingPaymentType.onlineCrypto],
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
    List<BookingPaymentType>? selectedPaymentTypes,
    bool? showSubsInContentCard,
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
      selectedPaymentTypes: selectedPaymentTypes ?? this.selectedPaymentTypes,
      showSubsInContentCard: showSubsInContentCard ?? this.showSubsInContentCard,
    );
  }

  @override
  String toString() {
    return 'BookingUiModel('
        'id: $id, '
        'price: $price, '
        'currency: $currency, '
        'bookingLimit: $bookingLimit, '
        'bookingLimitPerOne: $bookingLimitPerOne, '
        'subsUiModel: $subsUiModel, '
        'upsaleUiModel: $upsaleUiModel, '
        'selectedDateTime: $selectedDateTime, '
        'showSubsInContentCard: $showSubsInContentCard'
        ')';
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
        selectedPaymentTypes = const [BookingPaymentType.onlineCrypto],
        bookingLimit = '',
        bookingLimitPerOne = '',
        currency = 'AED',
        price = '',
        selectedDateTime = null,
        showSubsInContentCard = false,
        subsUiModel = List.empty(growable: true),
        upsaleUiModel = List.empty(growable: true);

  Map<String, dynamic> toMap() => {
        'id': id,
        'price': price,
        'currency': currency,
        'bookingLimit': bookingLimit,
        'bookingLimitPerOne': bookingLimitPerOne,
        'subsUiModel': subsUiModel?.map((e) => e.toMap()).toList(),
        'upsaleUiModel': upsaleUiModel?.map((e) => e.toMap()).toList(),
        'selectedDateTime': selectedDateTime?.toIso8601String(),
        'showSubsInContentCard': showSubsInContentCard,
        'selectedPaymentTypes': selectedPaymentTypes.map((e) => e.index).toList(),
      }..removeWhere((k, v) => v == null);

  static BookingUiModel fromMap(Map<String, dynamic> map) {
    print('retrieving BookingUiModel from map: $map');
    return BookingUiModel(
        id: map['id'] as int,
        price: map['price'] as String?,
        currency: map['currency'] as String?,
        bookingLimit: map['bookingLimit'] as String?,
        bookingLimitPerOne: map['bookingLimitPerOne'] as String?,
        subsUiModel: map['subsUiModel']?.map<SubsUiModel>((e) => SubsUiModel.fromMap(e))?.toList(),
        upsaleUiModel: map['upsaleUiModel']?.map<UpsaleUiModel>((e) => UpsaleUiModel.fromMap(e))?.toList(),
        selectedDateTime: (map['selectedDateTime']?.isEmpty ?? true) ? null : DateTime.parse(map['selectedDateTime']!),
        showSubsInContentCard: map['showSubsInContentCard'] as bool,
        selectedPaymentTypes: map['selectedPaymentTypes'] != null
            ? (map['selectedPaymentTypes'] as List).map((e) => fromIndex(e)).toList()
            : const []);
  }
}

enum BookingPaymentType { free, onlineCard, onlineCrypto, offlineCash, offlineQR }

extension BookingPaymentNames on BookingPaymentType {
  String get name {
    switch (this) {
      case BookingPaymentType.free:
        return S.current.Free;
      case BookingPaymentType.onlineCard:
        return '${S.current.ForMoney} (Stripe)';
      case BookingPaymentType.onlineCrypto:
        return S.current.ForCrypto;
      case BookingPaymentType.offlineCash:
        return S.current.Cash;
      case BookingPaymentType.offlineQR:
        return 'QR code';
    }
  }
}

BookingPaymentType fromIndex(int index) {
  switch (index) {
    case 0:
      return BookingPaymentType.free;
    case 1:
      return BookingPaymentType.onlineCard;
    case 2:
      return BookingPaymentType.onlineCrypto;
    case 3:
      return BookingPaymentType.offlineCash;
    case 4:
      return BookingPaymentType.offlineQR;
    default:
      return BookingPaymentType.free;
  }
}
