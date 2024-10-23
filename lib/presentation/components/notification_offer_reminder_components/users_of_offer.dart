import 'package:shuffle_components_kit/presentation/components/profile/uiprofile_model.dart';

class UsersOfOffer {
  final UiProfileModel? user;
  final bool isConfirm;
  final String? ticketNumber;

  UsersOfOffer({
    this.user,
    this.isConfirm = false,
    this.ticketNumber,
  });

  UsersOfOffer copyWith({
    UiProfileModel? user,
    bool? isConfirm,
    String? ticketNumber,
  }) {
    return UsersOfOffer(
      user: user ?? this.user,
      isConfirm: isConfirm ?? this.isConfirm,
      ticketNumber: ticketNumber ?? this.ticketNumber,
    );
  }
}
