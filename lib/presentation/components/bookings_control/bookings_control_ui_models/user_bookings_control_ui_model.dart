import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class UserBookingsControlUiModel {
  final int id;
  final UiProfileModel? profile;
  final TicketUiModel? ticketUiModel;
  final TicketUiModel? refundUiModel;
  bool isSelected;

  UserBookingsControlUiModel({
    required this.id,
    this.profile,
    this.ticketUiModel,
    this.refundUiModel,
    this.isSelected = false,
  });

  UserBookingsControlUiModel copyWith({
    int? id,
    UiProfileModel? profile,
    TicketUiModel? ticketUiModel,
    TicketUiModel? refundUiModel,
    bool? isSelected,
  }) {
    return UserBookingsControlUiModel(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      ticketUiModel: ticketUiModel ?? this.ticketUiModel,
      refundUiModel: refundUiModel ?? this.refundUiModel,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
