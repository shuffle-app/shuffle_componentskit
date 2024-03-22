class UiCompanyProfileModel {
  final String? selectedTab;
  final String? avatarUrl;
  final String? companyName;
  final String? contactNumber;
  final String? email;
  final String? contactPerson;
  final String? contactPersonPosition;
  final String? niche;
  final List<String> priceSegments;
  final List<String> ageRanges;

  UiCompanyProfileModel({
    this.selectedTab,
    this.avatarUrl,
    this.companyName,
    this.contactNumber,
    this.email,
    this.contactPerson,
    this.ageRanges = const [],
    this.priceSegments = const [],
    this.niche,
    this.contactPersonPosition,
  });

  UiCompanyProfileModel copyWith({
    String? selectedTab,
  }) {
    return UiCompanyProfileModel(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
