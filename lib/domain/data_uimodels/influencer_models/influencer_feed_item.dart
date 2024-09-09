import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../shuffle_components_kit.dart';

abstract class InfluencerFeedItem {
  final String speciality;
  final String name;
  final String username;
  final String avatarUrl;
  final UserTileType userType;

  InfluencerFeedItem({
    required this.speciality,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.userType,
  });
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
    required super.speciality,
    required super.name,
    required super.username,
    required super.avatarUrl,
    required super.userType,
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
    required super.speciality,
    required super.name,
    required super.username,
    required super.avatarUrl,
    required super.userType,
    required this.text,
    required this.heartEyesReactionsCount,
    required this.likeReactionsCount,
    required this.fireReactionsCount,
    required this.sunglassesReactionsCount,
    required this.smileyReactionsCount,
    this.newMark = false,
  });
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
