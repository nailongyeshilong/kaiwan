import '../../../shared/models/daily_draw_state.dart';

class DailyDrawStateStorageModel {
  const DailyDrawStateStorageModel({
    required this.dateKey,
    required this.remainingDrawCount,
    required this.isLocked,
    this.recommendedGameId,
    this.recommendedGameNameSnapshot,
    this.recommendedGameCoverImagePathSnapshot,
    this.lastDrawAt,
  });

  factory DailyDrawStateStorageModel.fromEntity(DailyDrawState entity) {
    return DailyDrawStateStorageModel(
      dateKey: entity.dateKey,
      remainingDrawCount: entity.remainingDrawCount,
      isLocked: entity.isLocked,
      recommendedGameId: entity.recommendedGameId,
      recommendedGameNameSnapshot: entity.recommendedGameNameSnapshot,
      recommendedGameCoverImagePathSnapshot:
          entity.recommendedGameCoverImagePathSnapshot,
      lastDrawAt: entity.lastDrawAt,
    );
  }

  final String dateKey;
  final int remainingDrawCount;
  final bool isLocked;
  final String? recommendedGameId;
  final String? recommendedGameNameSnapshot;
  final String? recommendedGameCoverImagePathSnapshot;
  final DateTime? lastDrawAt;

  DailyDrawState toEntity() {
    return DailyDrawState(
      dateKey: dateKey,
      remainingDrawCount: remainingDrawCount,
      isLocked: isLocked,
      recommendedGameId: recommendedGameId,
      recommendedGameNameSnapshot: recommendedGameNameSnapshot,
      recommendedGameCoverImagePathSnapshot:
          recommendedGameCoverImagePathSnapshot,
      lastDrawAt: lastDrawAt,
    );
  }
}
