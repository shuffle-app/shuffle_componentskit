import 'package:shuffle_components_kit/presentation/components/invite_to_favourite_places/ui_invite_to_favourite_places_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiInvitePersonModel extends UiInviteToFavoritePlacesModel {
  final int id;
  final String name;
  final String description;
  final String? avatarLink;
  final UserTileType userTileType;
  final int? rating;
  final bool? handshake;
  bool isSelected;

  UiInvitePersonModel({
    super.date,
    this.isSelected = false,
    required this.name,
    required this.id,
    this.rating,
    this.handshake,
    this.userTileType = UserTileType.ordinary,
    this.avatarLink,
    required this.description,
  });
}
