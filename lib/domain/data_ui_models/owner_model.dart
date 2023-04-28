class OwnerModel {
  final String name;
  final String? logo;
  final String id;
  final OwnerType type;

  OwnerModel({
    required this.name,
    this.logo,
    required this.id,
    required this.type,
  });
}

enum OwnerType { person, place }
