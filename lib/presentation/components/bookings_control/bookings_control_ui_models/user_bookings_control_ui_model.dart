import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class UserBookingsControlUiModel {
  final int id;
  final UiProfileModel? profile;
  final TicketUiModel? ticketUiModel;
  final TicketUiModel? refundUiModel;
  final int? noShows;
  bool isSelected;
  final DateTime? visitDate;
  final int? paymentType;

  UserBookingsControlUiModel({
    required this.id,
    this.profile,
    this.ticketUiModel,
    this.refundUiModel,
    this.noShows,
    this.isSelected = false,
    this.visitDate,
    this.paymentType,
  });

  UserBookingsControlUiModel copyWith({
    int? id,
    UiProfileModel? profile,
    TicketUiModel? ticketUiModel,
    TicketUiModel? refundUiModel,
    int? noShows,
    bool? isSelected,
    DateTime? visitDate,
    int? paymentType,
  }) {
    return UserBookingsControlUiModel(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      ticketUiModel: ticketUiModel ?? this.ticketUiModel,
      refundUiModel: refundUiModel ?? this.refundUiModel,
      noShows: noShows ?? this.noShows,
      isSelected: isSelected ?? this.isSelected,
      visitDate: visitDate ?? this.visitDate,
      paymentType: paymentType ?? this.paymentType,
    );
  }
}
