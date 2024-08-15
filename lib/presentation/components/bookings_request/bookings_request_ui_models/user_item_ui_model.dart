import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'request_refun_ui_model.dart';

class UserItemUiModel {
  final int id;
  final String? name;
  final String? nickName;
  final String? avatarUrl;
  final UserTileType? type;
  final int tiketsCount;
  final int? productsCount;
  final String? email;
  final RequestRefunUiModel? requestRefunUiModel;
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
    this.email,
    this.requestRefunUiModel,
  });

  UserItemUiModel copyWith({
    int? id,
    String? name,
    String? nickName,
    String? avatarUrl,
    UserTileType? type,
    int? tiketsCount,
    int? productsCount,
    String? email,
    RequestRefunUiModel? requestRefunUiModel,
  }) {
    return UserItemUiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      tiketsCount: tiketsCount ?? this.tiketsCount,
      productsCount: productsCount ?? this.productsCount,
      email: email ?? this.email,
      requestRefunUiModel: requestRefunUiModel ?? this.requestRefunUiModel,
    );
  }
}
