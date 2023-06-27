class OnBoardingPageItem {
  /// the image link can be a network image or an asset image
  final String imageLink;

  /// the title of the page
  final String title;

  /// if you need an item to stay longer than the default duration
  /// you can pass a custom duration
  final Duration autoSwitchDuration;

  const OnBoardingPageItem({
    required this.imageLink,
    required this.title,
    this.autoSwitchDuration = const Duration(milliseconds: 1500),
  });
}