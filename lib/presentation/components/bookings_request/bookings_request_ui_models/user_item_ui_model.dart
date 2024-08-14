import 'package:shuffle_uikit/shuffle_uikit.dart';

class UserItemUiModel {
  final int id;
  final String? name;
  final String? nickName;
  final String? avatarUrl;
  final UserTileType? type;
  final int tiketsCount;
  final int? productsCount;
  bool isSelected;
  UserItemUiModel({
    required this.id,
    required this.tiketsCount,
    this.name,
    this.nickName,
    this.avatarUrl,
    this.type,
    this.productsCount,
    this.isSelected = false,
  });

  UserItemUiModel copyWith({
    int? id,
    String? name,
    String? nickName,
    String? avatarUrl,
    UserTileType? type,
    int? tiketsCount,
    int? productsCount,
  }) {
    return UserItemUiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      tiketsCount: tiketsCount ?? this.tiketsCount,
      productsCount: productsCount ?? this.productsCount,
    );
  }
}
