class UiDonationUserModel {
  final int position;
  final String sum;
  final String nickname;
  final String name;
  final String surname;
  final String? points;
  final bool isStarEnabled;

  UiDonationUserModel({
    this.points,
    required this.position,
    required this.sum,
    required this.nickname,
    required this.name,
    required this.surname,
    required this.isStarEnabled,
  });
}
