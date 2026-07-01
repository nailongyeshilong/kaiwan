import 'package:flutter/foundation.dart';

@immutable
class Game {
  const Game({
    required this.id,
    required this.name,
    required this.coverImagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String coverImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Game copyWith({
    String? id,
    String? name,
    String? coverImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
