import 'package:shuffle_uikit/foundation/graphics_foundation.dart';

class CommentsUpdateUiModel {
  final String type;
  final int commentsCount;
  final DateTime lastCommentDate;
  final String lastComment;
  final String icon = GraphicsFoundation.instance.svg.message.path;

  CommentsUpdateUiModel({
    required this.type,
    required this.commentsCount,
    required this.lastCommentDate,
    required this.lastComment,
  });
}
