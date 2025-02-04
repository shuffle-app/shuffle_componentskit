import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shuffle_uikit/ui_kit/molecules/tiles/user/base_user_tile.dart';
import 'package:shuffle_uikit/ui_models/reaction/reaction_statistic_ui_model.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoReactionUiModel {
  final String videoUrl;
  final String? previewImageUrl;
  final String? authorAvatarUrl;
  final String? authorName;
  final String? answeredCompanyName;
  final String? answeredCompanyLogo;
  final DateTime? companyAnswerDateTime;
  final DateTime? videoReactionDateTime;
  final DateTime? eventDate;
  final int? answeredCompanyId;
  final String? placeName;
  final String? eventName;
  final int? placeId;
  final int authorId;
  final int id;
  final UserTileType authorType;
  final String parentContentType;
  final int parentContentId;
  final DateTime? createdAt;
  int? nextReactionId;
  int? previousReactionId;
  bool isViewed;
  VideoPlayerController? videoController;
  final String? tempDirPath;
  final ReactionStatisticUiModel? reactionStatisticUiModel;

  VideoReactionUiModel({
    required this.id,
    required this.authorId,
    required this.parentContentType,
    required this.parentContentId,
    required this.authorType,
    this.placeName,
    this.eventName,
    this.placeId,
    required this.videoUrl,
    this.previewImageUrl,
    this.authorName,
    this.authorAvatarUrl,
    this.answeredCompanyName,
    this.answeredCompanyLogo,
    this.companyAnswerDateTime,
    this.videoReactionDateTime,
    this.answeredCompanyId,
    this.eventDate,
    this.nextReactionId,
    this.previousReactionId,
    this.createdAt,
    this.isViewed = false,
    this.videoController,
    this.tempDirPath,
    this.reactionStatisticUiModel,
  }) {
    if (videoController != null) return;

    createController();
  }

  createController() async {
    if (kIsWeb) {
      videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    } else {
      try {
        Directory? tempDir = tempDirPath != null ? null : await getTemporaryDirectory();
        final filename = videoUrl.split('/').last;
        final fileFromCache =
            File('${tempDirPath ?? tempDir?.path}/video_cache/$id-$filename${filename.contains('.mp4') ? '' : '.mp4'}');
        if (fileFromCache.existsSync()) {
          videoController = VideoPlayerController.file(fileFromCache);
        } else {
          final videoData = await _getFileFromUrl(videoUrl);
          await fileFromCache.create(recursive: true);
          await fileFromCache.writeAsBytes(videoData);
          videoController = VideoPlayerController.file(fileFromCache);
        }
      } catch (e, st) {
        log('videoReaction retrieve from /video_cache/$id-${videoUrl.split('/').last} error: $e $st',
            name: 'VideoReactionUiModel');
      }
    }
  }

  bool get empty => id == -1;

  bool get isReactionForEvent => parentContentType == 'event';

  bool get isReactionForPlace => parentContentType == 'place';

  VideoReactionUiModel copyWith({
    String? videoUrl,
    String? previewImageUrl,
    String? authorAvatarUrl,
    String? authorName,
    String? answeredCompanyName,
    String? answeredCompanyLogo,
    DateTime? companyAnswerDateTime,
    DateTime? videoReactionDateTime,
    DateTime? eventDate,
    int? answeredCompanyId,
    int? placeId,
    String? placeName,
    int? nextReactionId,
    int? previousReactionId,
    bool? isViewed,
    UserTileType? authorType,
    DateTime? createdAt,
    ReactionStatisticUiModel? reactionStatisticUiModel,
  }) {
    return VideoReactionUiModel(
      id: id,
      authorId: authorId,
      parentContentType: parentContentType,
      parentContentId: parentContentId,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      videoUrl: videoUrl ?? this.videoUrl,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorName: authorName ?? this.authorName,
      answeredCompanyName: answeredCompanyName ?? this.answeredCompanyName,
      answeredCompanyLogo: answeredCompanyLogo ?? this.answeredCompanyLogo,
      companyAnswerDateTime: companyAnswerDateTime ?? this.companyAnswerDateTime,
      videoReactionDateTime: videoReactionDateTime ?? this.videoReactionDateTime,
      eventDate: eventDate ?? this.eventDate,
      answeredCompanyId: answeredCompanyId ?? this.answeredCompanyId,
      nextReactionId: nextReactionId ?? this.nextReactionId,
      previousReactionId: previousReactionId ?? this.previousReactionId,
      isViewed: isViewed ?? this.isViewed,
      authorType: authorType ?? this.authorType,
      createdAt: createdAt ?? this.createdAt,
      videoController: videoController,
      reactionStatisticUiModel: reactionStatisticUiModel ?? this.reactionStatisticUiModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VideoReactionUiModel && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

Future<Uint8List> _getFileFromUrl(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load data from $url');
  }
}
