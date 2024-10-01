import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:collection/collection.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MyBookingUiModel {
  final int id;
  final String? name;
  final TicketUiModel? ticketUiModel;
  final UiEventModel? eventModel;
  final UiPlaceModel? placeModel;
  final int? total;

  MyBookingUiModel({
    required this.id,
    this.name,
    this.ticketUiModel,
    this.total,
    this.eventModel,
    this.placeModel,
  });

  bool get isPast {
    final selectedDateTime =
        eventModel?.bookingUiModel?.selectedDateTime ?? placeModel?.bookingUiModel?.selectedDateTime;

    if (selectedDateTime != null) {
      return DateTime.now().isAfter(selectedDateTime);
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
}
