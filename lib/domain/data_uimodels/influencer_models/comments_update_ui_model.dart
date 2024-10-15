import 'package:flutter/cupertino.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class CommentsUpdateUiModel {
  final String type;
  final int commentsCount;
  final DateTime lastCommentDate;
  final String lastComment;
  final IconData icon = ShuffleUiKitIcons.message;

  CommentsUpdateUiModel({
    required this.type,
    required this.commentsCount,
    required this.lastCommentDate,
    required this.lastComment,
  });
}
