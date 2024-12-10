import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

abstract class InfluencerFeedItem {
  final int id;
  final GlobalKey? key;
  final String speciality;
  final String name;
  final String username;
  final String avatarUrl;
  final UserTileType userType;
  String? userReaction;
  final String? createdAt;

  InfluencerFeedItem({
    required this.id,
    this.key,
    required this.speciality,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.userType,
    this.userReaction,
    this.createdAt,
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
        'userReaction: $userReaction)';
  }

  @override
  bool operator ==(Object other) {
    return (other is InfluencerFeedItem || other is UpdatesFeedItem || other is ShufflePostFeedItem || other is PostFeedItem) &&
        (other as InfluencerFeedItem).id == id;
  }

  @override
  int get hashCode => id.hashCode;

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
    super.createdAt,
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
    super.createdAt,
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
      createdAt: createdAt,
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

  PostFeedItem({
    required super.id,
    required super.speciality,
    required super.name,
    required super.username,
    required super.avatarUrl,
    required super.userType,
    super.createdAt,
    required this.text,
    required this.heartEyesReactionsCount,
    required this.likeReactionsCount,
    required this.fireReactionsCount,
    required this.sunglassesReactionsCount,
    required this.smileyReactionsCount,
    super.key,
    super.userReaction,
    this.newMark = false,
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
  }) {
    return PostFeedItem(
      id: id,
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
      createdAt: createdAt,
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
