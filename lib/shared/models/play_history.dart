import 'package:flutter/foundation.dart';

@immutable
class PlayHistory {
  const PlayHistory({
    required this.id,
    required this.dateKey,
    required this.gameId,
    required this.gameNameSnapshot,
    required this.gameCoverImagePathSnapshot,
    required this.drawnAt,
  });

  final String id;
  final String dateKey;
  final String gameId;
  final String gameNameSnapshot;
  final String gameCoverImagePathSnapshot;
  final DateTime drawnAt;

  PlayHistory copyWith({
    String? id,
    String? dateKey,
    String? gameId,
    String? gameNameSnapshot,
    String? gameCoverImagePathSnapshot,
    DateTime? drawnAt,
  }) {
    return PlayHistory(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      gameId: gameId ?? this.gameId,
      gameNameSnapshot: gameNameSnapshot ?? this.gameNameSnapshot,
      gameCoverImagePathSnapshot:
          gameCoverImagePathSnapshot ?? this.gameCoverImagePathSnapshot,
      drawnAt: drawnAt ?? this.drawnAt,
    );
  }
}
