import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

class UiPlaceModel {
  int id;
  List<BaseUiKitMedia> media;
  List<String> weekdays;
  String description;
  List<UiKitTag> tags;
  List<UiKitTag> baseTags;
  double? rating;
  String? title;
  String? source;
  String? placeType;
  String? status;
  String? logo;
  List<UiDescriptionItemModel>? descriptionItems;
  String? scheduleString;
  String? location;
  String? website;
  String? phone;
  String? price;
  Future<List<HorizontalCaptionedImageData>?>? branches;
  Object? schedule;
  String? niche;
  String? contentType;
  int? userPoints;

  UiPlaceModel({
    required this.id,
    this.title,
    this.scheduleString,
    this.location,
    this.media = const [],
    this.logo,
    this.phone,
    this.website,
    this.source,
    required this.description,
    this.rating,
    this.status,
    this.price,
    this.placeType,
    this.branches,
    required this.tags,
    this.baseTags = const [],
    this.weekdays = const [],
    this.schedule,
    this.niche,
    this.contentType,
    this.userPoints,
  }) : descriptionItems = [
          UiDescriptionItemModel(
              title: S.current.Website,
              description: website != null && website.isNotEmpty ? title ?? '' : '',
              descriptionUrl: website ?? ''),
          UiDescriptionItemModel(title: S.current.Phone, description: phone ?? ''),
          UiDescriptionItemModel(title: S.current.Location, description: location ?? ''),
          if (scheduleString != null)
            UiDescriptionItemModel(
              title: S.current.WorkHours,
              description: scheduleString,
              // description: formatDate(null, null, openFrom, openTo, weekdays)!,
            ),
        ];

  String? validateCreation() {
    if (title == null || title!.isEmpty) {
      return S.current.XIsRequired(S.current.Title);
    } else if (description.isEmpty) {
      return S.current.XIsRequired(S.current.Description);
    } else if (media.isEmpty) {
      return S.current.XIsRequired(S.current.Photos);
    } else if (logo == null || logo!.isEmpty) {
      return S.current.XIsRequired(S.current.Logo);
    } else if (phone == null || phone!.isEmpty) {
      return S.current.XIsRequired(S.current.Phone);
    } else if (location == null || location!.isEmpty) {
      return S.current.XIsRequired(S.current.Location);
    }

    return null;
  }

  UiPlaceModel copyWith({
    int? id,
    List<BaseUiKitMedia>? media,
    List<String>? weekdays,
    String? description,
    List<UiKitTag>? tags,
    List<UiKitTag>? baseTags,
    double? rating,
    String? title,
    String? source,
    String? placeType,
    String? status,
    String? logo,
    List<UiDescriptionItemModel>? descriptionItems,
    String? scheduleString,
    String? location,
    String? website,
    String? phone,
    String? price,
    Future<List<HorizontalCaptionedImageData>?>? branches,
    Object? schedule,
    String? niche,
    String? contentType,
    int? userPoints,
  }) =>
      UiPlaceModel(
        id: id ?? this.id,
        media: media ?? this.media,
        weekdays: weekdays ?? this.weekdays,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        baseTags: baseTags ?? this.baseTags,
        rating: rating ?? this.rating,
        title: title ?? this.title,
        source: source ?? this.source,
        placeType: placeType ?? this.placeType,
        status: status ?? this.status,
        logo: logo ?? this.logo,
        scheduleString: scheduleString ?? this.scheduleString,
        location: location ?? this.location,
        website: website ?? this.website,
        phone: phone ?? this.phone,
        price: price ?? this.price,
        branches: branches ?? this.branches,
        schedule: schedule ?? this.schedule,
        niche: niche ?? this.niche,
        contentType: contentType ?? this.contentType,
        userPoints: userPoints ?? this.userPoints,
      );

  UiPlaceModel.empty()
      : id = -1,
        media = [],
        weekdays = [],
        description = '',
        tags = [],
        baseTags = [];
}
