import '../../../shared/models/play_history.dart';

class PlayHistoryStorageModel {
  const PlayHistoryStorageModel({
    required this.id,
    required this.dateKey,
    required this.gameId,
    required this.gameNameSnapshot,
    required this.gameCoverImagePathSnapshot,
    required this.drawnAt,
  });

  factory PlayHistoryStorageModel.fromEntity(PlayHistory entity) {
    return PlayHistoryStorageModel(
      id: entity.id,
      dateKey: entity.dateKey,
      gameId: entity.gameId,
      gameNameSnapshot: entity.gameNameSnapshot,
      gameCoverImagePathSnapshot: entity.gameCoverImagePathSnapshot,
      drawnAt: entity.drawnAt,
    );
  }

  final String id;
  final String dateKey;
  final String gameId;
  final String gameNameSnapshot;
  final String gameCoverImagePathSnapshot;
  final DateTime drawnAt;

  PlayHistory toEntity() {
    return PlayHistory(
      id: id,
      dateKey: dateKey,
      gameId: gameId,
      gameNameSnapshot: gameNameSnapshot,
      gameCoverImagePathSnapshot: gameCoverImagePathSnapshot,
      drawnAt: drawnAt,
    );
  }
}
