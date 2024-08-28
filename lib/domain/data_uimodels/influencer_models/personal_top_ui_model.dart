import '../../../presentation/components/feed/uifeed_model.dart';

class PersonalTopUiModel {
  final String title;
  final String subtitle;
  final List<UiUniversalModel>? topContent;

  PersonalTopUiModel({
    required this.title,
    required this.subtitle,
    this.topContent,
  });
}
