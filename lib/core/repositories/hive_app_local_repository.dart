import 'dart:async';

import '../logger/app_logger.dart';
import '../storage/hive_boxes.dart';
import '../storage/models/daily_draw_state_storage_model.dart';
import '../storage/models/game_storage_model.dart';
import '../storage/models/play_history_storage_model.dart';
import '../utils/date_key_formatter.dart';
import '../../shared/models/daily_draw_state.dart';
import '../../shared/models/game.dart';
import '../../shared/models/play_history.dart';
import 'app_local_repository.dart';

class HiveAppLocalRepository implements AppLocalRepository {
  const HiveAppLocalRepository();

  @override
  Stream<List<Game>> watchGames() async* {
    yield await getGames();
    yield* HiveBoxes.games.watch().asyncMap((_) => getGames());
  }

  @override
  Future<List<Game>> getGames() async {
    try {
      final games = HiveBoxes.games.values
          .map((game) => game.toEntity())
          .toList()
        ..sort((left, right) => right.updatedAt.compareTo(left.updatedAt));

      return games;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load games from Hive.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Future<void> saveGame(Game game) async {
    try {
      await HiveBoxes.games.put(game.id, GameStorageModel.fromEntity(game));
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save game ${game.id}.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteGame(String gameId) async {
    try {
      await HiveBoxes.games.delete(gameId);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to delete game $gameId.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Future<bool> isGameNameTaken({
    required String name,
    String? excludingGameId,
  }) async {
    try {
      final normalizedName = _normalizeName(name);

      for (final GameStorageModel storageModel in HiveBoxes.games.values) {
        final isExcluded = storageModel.id == excludingGameId;
        if (isExcluded) {
          continue;
        }

        if (_normalizeName(storageModel.name) == normalizedName) {
          return true;
        }
      }

      return false;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to validate game name uniqueness.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Stream<List<PlayHistory>> watchPlayHistories() async* {
    yield await getPlayHistories();
    yield* HiveBoxes.playHistories.watch().asyncMap((_) => getPlayHistories());
  }

  @override
  Future<List<PlayHistory>> getPlayHistories() async {
    try {
      final histories = HiveBoxes.playHistories.values
          .map((history) => history.toEntity())
          .toList()
        ..sort((left, right) => right.drawnAt.compareTo(left.drawnAt));

      return histories;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load play histories from Hive.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Future<void> savePlayHistory(PlayHistory playHistory) async {
    try {
      await HiveBoxes.playHistories.put(
        playHistory.id,
        PlayHistoryStorageModel.fromEntity(playHistory),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save play history ${playHistory.id}.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Stream<DailyDrawState> watchTodayDrawState() async* {
    yield await getTodayDrawState();
    yield* HiveBoxes.dailyDrawStates
        .watch()
        .asyncMap((_) => getTodayDrawState());
  }

  @override
  Future<DailyDrawState> getTodayDrawState() async {
    try {
      final todayDateKey = buildDateKey(DateTime.now());
      await clearExpiredDailyDrawStates(todayDateKey);

      final storageModel = HiveBoxes.dailyDrawStates.get(todayDateKey);
      if (storageModel != null) {
        return storageModel.toEntity();
      }

      final initialState = DailyDrawState.initial(dateKey: todayDateKey);
      await saveDailyDrawState(initialState);
      return initialState;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load today daily draw state from Hive.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Future<void> saveDailyDrawState(DailyDrawState dailyDrawState) async {
    try {
      await HiveBoxes.dailyDrawStates.put(
        dailyDrawState.dateKey,
        DailyDrawStateStorageModel.fromEntity(dailyDrawState),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to save daily draw state ${dailyDrawState.dateKey}.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  @override
  Future<void> clearExpiredDailyDrawStates(String currentDateKey) async {
    final expiredKeys = HiveBoxes.dailyDrawStates.keys
        .whereType<String>()
        .where((key) => key != currentDateKey)
        .toList();

    if (expiredKeys.isEmpty) {
      return;
    }

    try {
      await HiveBoxes.dailyDrawStates.deleteAll(expiredKeys);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to clear expired daily draw states.',
        error: error,
        stackTrace: stackTrace,
        scope: 'HiveAppLocalRepository',
      );
      rethrow;
    }
  }

  String _normalizeName(String name) {
    return name.trim().toLowerCase();
  }
}
