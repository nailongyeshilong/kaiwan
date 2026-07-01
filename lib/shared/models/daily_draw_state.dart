import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';

@immutable
class DailyDrawState {
  const DailyDrawState({
    required this.dateKey,
    required this.remainingDrawCount,
    required this.isLocked,
    this.recommendedGameId,
    this.recommendedGameNameSnapshot,
    this.recommendedGameCoverImagePathSnapshot,
    this.lastDrawAt,
  });

  factory DailyDrawState.initial({
    required String dateKey,
  }) {
    return DailyDrawState(
      dateKey: dateKey,
      remainingDrawCount: AppConstants.maxDailyDrawCount,
      isLocked: false,
    );
  }

  final String dateKey;
  final int remainingDrawCount;
  final bool isLocked;
  final String? recommendedGameId;
  final String? recommendedGameNameSnapshot;
  final String? recommendedGameCoverImagePathSnapshot;
  final DateTime? lastDrawAt;

  bool get hasResult =>
      recommendedGameId != null &&
      recommendedGameNameSnapshot != null &&
      recommendedGameCoverImagePathSnapshot != null;

  DailyDrawState copyWith({
    String? dateKey,
    int? remainingDrawCount,
    bool? isLocked,
    String? recommendedGameId,
    String? recommendedGameNameSnapshot,
    String? recommendedGameCoverImagePathSnapshot,
    DateTime? lastDrawAt,
    bool clearRecommendedGameId = false,
    bool clearRecommendedGameNameSnapshot = false,
    bool clearRecommendedGameCoverImagePathSnapshot = false,
    bool clearLastDrawAt = false,
  }) {
    return DailyDrawState(
      dateKey: dateKey ?? this.dateKey,
      remainingDrawCount: remainingDrawCount ?? this.remainingDrawCount,
      isLocked: isLocked ?? this.isLocked,
      recommendedGameId: clearRecommendedGameId
          ? null
          : recommendedGameId ?? this.recommendedGameId,
      recommendedGameNameSnapshot: clearRecommendedGameNameSnapshot
          ? null
          : recommendedGameNameSnapshot ?? this.recommendedGameNameSnapshot,
      recommendedGameCoverImagePathSnapshot:
          clearRecommendedGameCoverImagePathSnapshot
              ? null
              : recommendedGameCoverImagePathSnapshot ??
                  this.recommendedGameCoverImagePathSnapshot,
      lastDrawAt: clearLastDrawAt ? null : lastDrawAt ?? this.lastDrawAt,
    );
  }
}
