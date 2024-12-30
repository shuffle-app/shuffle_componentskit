import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/subs_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';

class TicketUiModel {
  final int id;
  final int ticketsCount;
  final List<TicketItem<UpsaleUiModel>?>? upsales;
  TicketItem<SubsUiModel>? subs;
  final Map<String, bool>? mapTickets;

  TicketUiModel({
    required this.id,
    this.ticketsCount = 0,
    this.upsales,
    this.subs,
    this.mapTickets,
  });

  TicketUiModel.refund({
    this.id = -1,
    this.ticketsCount = 0,
    this.upsales,
    this.subs,
    this.mapTickets,
  });

  int get totalUpsalesCount {
    if (upsales == null) {
      return 0;
    }

    return upsales!.fold(0, (sum, item) => sum + (item?.count ?? 0));
  }

  int get totalUpsalePrice {
    if (upsales == null) {
      return 0;
    }
    int total = 0;
    upsales?.forEach(
      (element) {
        total += (element?.count ?? 0) * int.parse(element?.item?.price ?? '0');
      },
    );

    return total;
  }

  // int get totalSubsCount {
  //   if (subs == null) {
  //     return 0;
  //   }

  //   return subs!.fold(0, (sum, item) => sum + (item?.count ?? 0));
  // }

  TicketUiModel copyWith({
    int? id,
    int? ticketsCount,
    List<TicketItem<UpsaleUiModel>?>? upsales,
    TicketItem<SubsUiModel>? subs,
    Map<String, bool>? mapTickets,
  }) {
    return TicketUiModel(
      id: id ?? this.id,
      ticketsCount: ticketsCount ?? this.ticketsCount,
      upsales: upsales ?? this.upsales,
      subs: subs ?? this.subs,
      mapTickets: this.mapTickets ?? mapTickets,
    );
  }
}

class TicketItem<T> {
  final int? count;
  final T? item;
  final int? maxCount;

  TicketItem({
    this.count,
    this.item,
    this.maxCount,
  });

  TicketItem<T> copyWith({
    int? count,
    T? item,
    int? maxCount,
  }) {
    return TicketItem(
      count: count ?? this.count,
      item: item ?? this.item,
      maxCount: maxCount ?? this.maxCount,
    );
  }

  @override
  String toString() {
    return 'TicketItem(count: $count, item: $item, maxCount: $maxCount)';
  }
}
