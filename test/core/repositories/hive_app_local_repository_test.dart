import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:kaiplay/core/repositories/hive_app_local_repository.dart';
import 'package:kaiplay/core/storage/hive_storage_initializer.dart';
import 'package:kaiplay/core/utils/date_key_formatter.dart';
import 'package:kaiplay/shared/models/daily_draw_state.dart';
import 'package:kaiplay/shared/models/game.dart';
import 'package:kaiplay/shared/models/play_history.dart';

void main() {
  late Directory tempDirectory;
  late HiveAppLocalRepository repository;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('kaiplay_hive_test_');
    await HiveStorageInitializer.resetForTest();
    await HiveStorageInitializer.initializeWithPath(tempDirectory.path);
    repository = const HiveAppLocalRepository();
  });

  tearDown(() async {
    await HiveStorageInitializer.resetForTest();
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('persists games, daily draw state, and play history', () async {
    final now = DateTime.now();
    final dateKey = buildDateKey(now);
    final game = Game(
      id: 'game-1',
      name: 'Starbound',
      coverImagePath: '/tmp/starbound.png',
      createdAt: now,
      updatedAt: now,
    );
    final dailyDrawState = DailyDrawState(
      dateKey: dateKey,
      remainingDrawCount: 2,
      isLocked: false,
      recommendedGameId: game.id,
      recommendedGameNameSnapshot: game.name,
      recommendedGameCoverImagePathSnapshot: game.coverImagePath,
      lastDrawAt: now,
    );
    final playHistory = PlayHistory(
      id: 'history-1',
      dateKey: dateKey,
      gameId: game.id,
      gameNameSnapshot: game.name,
      gameCoverImagePathSnapshot: game.coverImagePath,
      drawnAt: now,
    );

    await repository.saveGame(game);
    await repository.saveDailyDrawState(dailyDrawState);
    await repository.savePlayHistory(playHistory);

    final games = await repository.getGames();
    final restoredDailyDrawState = await repository.getTodayDrawState();
    final histories = await repository.getPlayHistories();

    expect(games, hasLength(1));
    expect(games.first.name, 'Starbound');
    expect(restoredDailyDrawState.dateKey, dateKey);
    expect(restoredDailyDrawState.recommendedGameId, game.id);
    expect(histories, hasLength(1));
    expect(histories.first.gameNameSnapshot, 'Starbound');
  });
}
