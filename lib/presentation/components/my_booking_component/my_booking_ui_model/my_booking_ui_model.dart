import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:collection/collection.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MyBookingUiModel {
  final int id;
  final String? name;
  final TicketUiModel? ticketUiModel;
  final UiEventModel? eventModel;
  final UiPlaceModel? placeModel;
  final DateTime? visitDate;
  final int? total;
  final String? categoryName;
  final TicketIssueStatus? status;

  const MyBookingUiModel({
    required this.id,
    this.name,
    this.ticketUiModel,
    this.total,
    this.eventModel,
    this.placeModel,
    this.visitDate,
    this.categoryName,
    this.status,
  });

  bool get isPast {
    if (visitDate != null) {
      return DateTime.now().toLocal().isAfter(visitDate!);
    } else {
      return false;
    }
  }

  String? get currency {
    if (eventModel != null) {
      return eventModel?.currency;
    } else if (placeModel != null) {
      return placeModel?.currency;
    }
    return null;
  }

  DateTime? get dateTime {
    if (eventModel != null) {
      return eventModel?.bookingUiModel?.selectedDateTime;
    } else if (placeModel != null) {
      return placeModel?.bookingUiModel?.selectedDateTime;
    }
    return null;
  }

  String? get contentName => eventModel?.title ?? placeModel?.title;

  String? get contentLogo =>
      placeModel?.logo ??
      eventModel?.verticalPreview?.link ??
      eventModel?.media.firstWhereOrNull((e) => e.type == UiKitMediaType.image)?.link;

  @override
  bool operator ==(Object other) => other is MyBookingUiModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  MyBookingUiModel copyWith({
    int? id,
    String? name,
    TicketUiModel? ticketUiModel,
    int? total,
    UiEventModel? eventModel,
    UiPlaceModel? placeModel,
    DateTime? visitDate,
    String? categoryName,
    TicketIssueStatus? status,
  }) =>
      MyBookingUiModel(
        id: id ?? this.id,
        name: name ?? this.name,
        ticketUiModel: ticketUiModel ?? this.ticketUiModel,
        total: total ?? this.total,
        eventModel: eventModel ?? this.eventModel,
        placeModel: placeModel ?? this.placeModel,
        visitDate: visitDate ?? this.visitDate,
        categoryName: categoryName ?? this.categoryName,
        status: status ?? this.status,
      );
}

enum TicketIssueStatus {
  unpaid,
  paid,
  cancelled,
  refunded,
}
