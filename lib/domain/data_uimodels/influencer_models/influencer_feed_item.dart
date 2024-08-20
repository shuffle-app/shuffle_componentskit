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
  final List<UiKitMediaVideo>? newVideos;
  final List<FeedbackUiModel>? newFeedbacks;
  final List<VideoReactionUiModel>? newVideoReactions;
  final List<VoiceMessageUiModel>? newVoices;
  final List<EntertainmentRouteUiModel>? newRoutes;
  final List<VideoInterviewUiModel>? newVideoInterviews;
  final List<InfluencerContestUiModel>? newContests;
  final List<PersonalTopUiModel>? newPersonalTops;
  final List<PersonalRespectUiModel>? newPersonalRespects;
  final CommentsUpdateUiModel? commentsUpdate;

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
  });
}

class PostFeedItem extends InfluencerFeedItem {
  final String text;
  final int heartEyesReactionsCount;
  final int likeReactionsCount;
  final int fireReactionsCount;
  final int sunglassesReactionsCount;
  final int smileyReactionsCount;

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
  });
}
