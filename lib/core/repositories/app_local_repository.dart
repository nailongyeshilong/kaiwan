import '../../shared/models/daily_draw_state.dart';
import '../../shared/models/game.dart';
import '../../shared/models/play_history.dart';

abstract interface class AppLocalRepository {
  Stream<List<Game>> watchGames();

  Future<List<Game>> getGames();

  Future<void> saveGame(Game game);

  Future<void> deleteGame(String gameId);

  Future<bool> isGameNameTaken({
    required String name,
    String? excludingGameId,
  });

  Stream<List<PlayHistory>> watchPlayHistories();

  Future<List<PlayHistory>> getPlayHistories();

  Future<void> savePlayHistory(PlayHistory playHistory);

  Stream<DailyDrawState> watchTodayDrawState();

  Future<DailyDrawState> getTodayDrawState();

  Future<void> saveDailyDrawState(DailyDrawState dailyDrawState);

  Future<void> clearExpiredDailyDrawStates(String currentDateKey);
}
