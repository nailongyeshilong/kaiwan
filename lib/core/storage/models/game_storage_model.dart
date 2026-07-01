import '../../../shared/models/game.dart';

class GameStorageModel {
  const GameStorageModel({
    required this.id,
    required this.name,
    required this.coverImagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameStorageModel.fromEntity(Game entity) {
    return GameStorageModel(
      id: entity.id,
      name: entity.name,
      coverImagePath: entity.coverImagePath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  final String id;
  final String name;
  final String coverImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Game toEntity() {
    return Game(
      id: id,
      name: name,
      coverImagePath: coverImagePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
