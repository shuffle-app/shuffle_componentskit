import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/subs_or_upsale_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/booking_component/booking_ui_model/upsale_ui_model.dart';

class TicketUiModel {
  final int id;
  final int ticketsCount;
  final List<TicketItem<UpsaleUiModel>?>? upsales;
  final List<TicketItem<SubsUiModel>?>? subs;

  TicketUiModel({
    required this.id,
    this.ticketsCount = 0,
    this.upsales,
    this.subs,
  });

  int get totalUpsalesCount {
    if (upsales == null) {
      return 0;
    }

    return upsales!.fold(0, (sum, item) => sum + (item?.count ?? 0));
  }
}

class TicketItem<T> {
  final int? count;
  final T? item;

  TicketItem({
    this.count,
    this.item,
  });
}
