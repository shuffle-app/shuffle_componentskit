import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

abstract class InfluencerFeedItem {
  final int id;
  final int? userId;
  final GlobalKey? key;
  final String speciality;
  final String name;
  final String username;
  final String avatarUrl;
  final UserTileType userType;
  String? userReaction;
  final ViewShareDate? viewShareDate;
  final bool showTranslateButton;
  final AsyncValueGetter<String?>? onTranslateTap;
  final ValueNotifier<String>? translateText;

  InfluencerFeedItem({
    required this.id,
    this.key,
    required this.speciality,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.userType,
    this.userReaction,
    this.userId,
    this.viewShareDate,
    this.showTranslateButton = false,
    this.onTranslateTap,
    this.translateText,
  });

  @override
  String toString() {
    return 'InfluencerFeedItem('
        'id: $id, '
        'speciality: $speciality, '
        'name: $name, '
        'username: $username, '
        'avatarUrl: $avatarUrl, '
        'userType: $userType, '
        'userReaction: $userReaction,)'
        'showTranslateButton: ${showTranslateButton}';
  }

  @override
  bool operator ==(Object other) {
    return (other is InfluencerFeedItem ||
            other is UpdatesFeedItem ||
            other is ShufflePostFeedItem ||
            other is PostFeedItem ||
            other is DigestFeedItem) &&
        (other as InfluencerFeedItem).id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class DigestFeedItem extends InfluencerFeedItem {
  final String? title;
  final String? underTitleText;
  final List<DigestUiModel>? digestUiModels;
  final int heartEyesReactionsCount;
  final int likeReactionsCount;
  final int fireReactionsCount;
  final int sunglassesReactionsCount;
  final int smileyReactionsCount;
  final VoidCallback? onReadTap;
  final AsyncValueGetter<List<String>>? onTranslateListTap;

  DigestFeedItem({
    required super.id,
    required super.key,
    this.title,
    this.underTitleText,
    this.digestUiModels,
    this.heartEyesReactionsCount = 0,
    this.likeReactionsCount = 0,
    this.fireReactionsCount = 0,
    this.sunglassesReactionsCount = 0,
    this.smileyReactionsCount = 0,
    this.onReadTap,
    super.viewShareDate,
    super.userReaction,
    super.translateText,
    super.showTranslateButton,
    this.onTranslateListTap,
  }) : super(
          speciality: '',
          name: 'Shuffle',
          username: '',
          avatarUrl: GraphicsFoundation.instance.png.avatars.avatar13.path,
          userType: UserTileType.influencer,
        );

  DigestFeedItem copyWith({
    String? title,
    String? underTitleText,
    List<DigestUiModel>? digestUiModels,
    int? heartEyesReactionsCount,
    int? likeReactionsCount,
    int? fireReactionsCount,
    int? sunglassesReactionsCount,
    int? smileyReactionsCount,
    VoidCallback? onReadTap,
    String? userReaction,
    ValueNotifier<String>? translateText,
    AsyncValueGetter<List<String>>? onTranslateListTap,
  }) {
    return DigestFeedItem(
      key: super.key,
      id: id,
      viewShareDate: viewShareDate,
      title: title ?? this.title,
      underTitleText: underTitleText ?? this.underTitleText,
      digestUiModels: digestUiModels ?? this.digestUiModels,
      heartEyesReactionsCount: heartEyesReactionsCount ?? this.heartEyesReactionsCount,
      likeReactionsCount: likeReactionsCount ?? this.likeReactionsCount,
      fireReactionsCount: fireReactionsCount ?? this.fireReactionsCount,
      sunglassesReactionsCount: sunglassesReactionsCount ?? this.sunglassesReactionsCount,
      smileyReactionsCount: smileyReactionsCount ?? this.smileyReactionsCount,
      onReadTap: onReadTap ?? this.onReadTap,
      userReaction: userReaction,
      translateText: translateText ?? super.translateText,
      showTranslateButton: super.showTranslateButton,
      onTranslateListTap: onTranslateListTap ?? this.onTranslateListTap,
    );
  }
}

class UpdatesFeedItem extends InfluencerFeedItem {
  final List<UiKitMediaPhoto>? newPhotos;
  final List<VideoUpdateItem>? newVideos;
  final List<ReviewsUpdateItem>? newFeedbacks;
  final List<VideoReactionUiModel>? newVideoReactions;
  final List<VoiceMessageUiModel>? newVoices;
  final List<EntertainmentRouteUiModel>? newRoutes;
  final List<VideoInterviewUiModel>? newVideoInterviews;
  final List<InfluencerContestUiModel>? newContests;
  final List<PersonalTopUiModel>? newPersonalTops;
  final List<PersonalRespectUiModel>? newPersonalRespects;
  final CommentsUpdateUiModel? commentsUpdate;
  final List<UiUniversalModel>? newContent;

  UpdatesFeedItem({
    required super.id,
    required super.speciality,
    required super.name,
    required super.username,
    required super.avatarUrl,
    required super.userType,
    super.userReaction,
    super.key,
    super.viewShareDate,
    this.newPhotos,
    this.newVideos,
    this.newFeedbacks,
    this.newVideoReactions,
    this.newVoices,
    this.newRoutes,
    this.newVideoInterviews,
    this.newContests,
    this.newPersonalTops,
    this.newPersonalRespects,
    this.commentsUpdate,
    this.newContent,
    super.showTranslateButton,
    super.onTranslateTap,
    super.translateText,
  });
}

class ShufflePostFeedItem extends UpdatesFeedItem {
  final String text;
  final int heartEyesReactionsCount;
  final int likeReactionsCount;
  final int fireReactionsCount;
  final int sunglassesReactionsCount;
  final int smileyReactionsCount;
  final List<UiKitMediaVideo>? videos;

  ShufflePostFeedItem({
    required this.text,
    required super.id,
    super.key,
    super.userReaction,
    super.viewShareDate,
    this.videos,
    this.heartEyesReactionsCount = 0,
    this.likeReactionsCount = 0,
    this.fireReactionsCount = 0,
    this.sunglassesReactionsCount = 0,
    this.smileyReactionsCount = 0,
    super.newPhotos,
    super.newVideos,
    super.newFeedbacks,
    super.newVideoReactions,
    super.newVoices,
    super.newRoutes,
    super.newVideoInterviews,
    super.newContests,
    super.newPersonalTops,
    super.newPersonalRespects,
    super.commentsUpdate,
    super.newContent,
    super.translateText,
    super.showTranslateButton,
    super.onTranslateTap,
  }) : super(
          speciality: '',
          name: 'Shuffle',
          username: '',
          avatarUrl: GraphicsFoundation.instance.png.avatars.avatar13.path,
          userType: UserTileType.influencer,
        );

  ShufflePostFeedItem copyWith({
    String? text,
    int? heartEyesReactionsCount,
    int? likeReactionsCount,
    int? fireReactionsCount,
    int? sunglassesReactionsCount,
    int? smileyReactionsCount,
    List<UiKitMediaVideo>? videos,
    String? userReaction,
    ValueNotifier<String>? translateText,
  }) {
    return ShufflePostFeedItem(
      id: id,
      text: text ?? this.text,
      videos: videos ?? this.videos,
      heartEyesReactionsCount: heartEyesReactionsCount ?? this.heartEyesReactionsCount,
      likeReactionsCount: likeReactionsCount ?? this.likeReactionsCount,
      fireReactionsCount: fireReactionsCount ?? this.fireReactionsCount,
      sunglassesReactionsCount: sunglassesReactionsCount ?? this.sunglassesReactionsCount,
      smileyReactionsCount: smileyReactionsCount ?? this.smileyReactionsCount,
      newPhotos: newPhotos,
      newVideos: newVideos,
      newFeedbacks: newFeedbacks,
      newVideoReactions: newVideoReactions,
      newVoices: newVoices,
      newRoutes: newRoutes,
      newVideoInterviews: newVideoInterviews,
      newContests: newContests,
      newPersonalTops: newPersonalTops,
      newPersonalRespects: newPersonalRespects,
      commentsUpdate: commentsUpdate,
      newContent: newContent,
      userReaction: userReaction,
      key: super.key,
      viewShareDate: viewShareDate,
      translateText: translateText ?? super.translateText,
      showTranslateButton: super.showTranslateButton,
      onTranslateTap: super.onTranslateTap,
    );
  }
}

class PostFeedItem extends InfluencerFeedItem {
  final String text;
  final int heartEyesReactionsCount;
  final int likeReactionsCount;
  final int fireReactionsCount;
  final int sunglassesReactionsCount;
  final int smileyReactionsCount;
  final bool newMark;
  final DateTime? createAt;

  PostFeedItem({
    required super.id,
    required super.userId,
    super.speciality = '',
    super.name = '',
    super.username = '',
    super.avatarUrl = '',
    super.userType = UserTileType.ordinary,
    super.viewShareDate,
    required this.text,
    this.heartEyesReactionsCount = 0,
    this.likeReactionsCount = 0,
    this.fireReactionsCount = 0,
    this.sunglassesReactionsCount = 0,
    this.smileyReactionsCount = 0,
    super.key,
    super.userReaction,
    this.newMark = false,
    super.translateText,
    super.showTranslateButton,
    super.onTranslateTap,
    this.createAt,
  });

  PostFeedItem copyWith({
    String? text,
    int? heartEyesReactionsCount,
    int? likeReactionsCount,
    int? fireReactionsCount,
    int? sunglassesReactionsCount,
    int? smileyReactionsCount,
    bool? newMark,
    String? speciality,
    String? name,
    String? username,
    String? userType,
    String? userReaction,
    ValueNotifier<String>? translateText,
    int? userId,
    DateTime? createAt,
  }) {
    return PostFeedItem(
      id: id,
      userId: userId ?? this.userId,
      avatarUrl: super.avatarUrl,
      userType: super.userType,
      speciality: speciality ?? this.speciality,
      name: name ?? this.name,
      username: username ?? this.username,
      text: text ?? this.text,
      heartEyesReactionsCount: heartEyesReactionsCount ?? this.heartEyesReactionsCount,
      likeReactionsCount: likeReactionsCount ?? this.likeReactionsCount,
      fireReactionsCount: fireReactionsCount ?? this.fireReactionsCount,
      sunglassesReactionsCount: sunglassesReactionsCount ?? this.sunglassesReactionsCount,
      smileyReactionsCount: smileyReactionsCount ?? this.smileyReactionsCount,
      newMark: newMark ?? this.newMark,
      userReaction: userReaction,
      key: key,
      viewShareDate: viewShareDate,
      translateText: translateText ?? super.translateText,
      showTranslateButton: super.showTranslateButton,
      createAt: this.createAt ?? createAt,
      onTranslateTap: super.onTranslateTap,
    );
  }
}

class VideoUpdateItem {
  final String previewImage;
  final String? subtitle;
  final UiKitMediaVideo media;

  VideoUpdateItem({
    required this.previewImage,
    required this.media,
    this.subtitle,
  });
}

class ReviewsUpdateItem {
  final String previewImage;
  final String? subtitle;

  ReviewsUpdateItem({
    required this.previewImage,
    this.subtitle,
  });
}
