class UiCompanyProfileModel {
  final String? selectedTab;

  UiCompanyProfileModel({
    this.selectedTab,
  });

  UiCompanyProfileModel copyWith({
    String? selectedTab,
  }) {
    return UiCompanyProfileModel(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
