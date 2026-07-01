import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:kaiplay/core/repositories/hive_app_local_repository.dart';
import 'package:kaiplay/core/storage/hive_storage_initializer.dart';
import 'package:kaiplay/core/utils/date_key_formatter.dart';
import 'package:kaiplay/features/home/data/repositories/hive_home_repository.dart';
import 'package:kaiplay/features/home/data/services/home_game_picker.dart';
import 'package:kaiplay/features/home/domain/entities/home_draw_result.dart';
import 'package:kaiplay/shared/models/daily_draw_state.dart';
import 'package:kaiplay/shared/models/game.dart';

void main() {
  late Directory tempDirectory;
  late HiveAppLocalRepository localRepository;
  late HiveHomeRepository repository;

  setUp(() async {
    tempDirectory =
        await Directory.systemTemp.createTemp('kaiplay_home_repository_test_');
    await HiveStorageInitializer.resetForTest();
    await HiveStorageInitializer.initializeWithPath(tempDirectory.path);
    localRepository = const HiveAppLocalRepository();
  });

  tearDown(() async {
    await HiveStorageInitializer.resetForTest();
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('returns empty-pool result when no games exist', () async {
    repository = HiveHomeRepository(
      localRepository,
      _SequenceHomeGamePicker(const <String>[]),
    );

    final result = await repository.drawGame();

    expect(result.type, HomeDrawResultType.emptyPool);
    final todayState = await localRepository.getTodayDrawState();
    expect(todayState.remainingDrawCount, 3);
    expect(todayState.hasResult, isFalse);
  });

  test('draw flow decrements count, overwrites result, and locks on third draw',
      () async {
    final games = await seedGames(localRepository);
    repository = HiveHomeRepository(
      localRepository,
      _SequenceHomeGamePicker([
        games[0].id,
        games[1].id,
        games[0].id,
      ]),
    );

    final firstResult = await repository.drawGame();
    expect(firstResult.type, HomeDrawResultType.success);
    var todayState = await localRepository.getTodayDrawState();
    expect(todayState.remainingDrawCount, 2);
    expect(todayState.isLocked, isFalse);
    expect(todayState.recommendedGameNameSnapshot, games[0].name);
    expect((await localRepository.getPlayHistories()), isEmpty);

    final secondResult = await repository.drawGame();
    expect(secondResult.type, HomeDrawResultType.success);
    todayState = await localRepository.getTodayDrawState();
    expect(todayState.remainingDrawCount, 1);
    expect(todayState.isLocked, isFalse);
    expect(todayState.recommendedGameNameSnapshot, games[1].name);
    expect((await localRepository.getPlayHistories()), isEmpty);

    final thirdResult = await repository.drawGame();
    expect(thirdResult.type, HomeDrawResultType.success);
    todayState = await localRepository.getTodayDrawState();
    expect(todayState.remainingDrawCount, 0);
    expect(todayState.isLocked, isTrue);
    expect(todayState.recommendedGameNameSnapshot, games[0].name);

    final histories = await localRepository.getPlayHistories();
    expect(histories, hasLength(1));
    expect(histories.first.gameId, games[0].id);
    expect(histories.first.gameNameSnapshot, games[0].name);
    expect(histories.first.gameCoverImagePathSnapshot, games[0].coverImagePath);
    expect(histories.first.dateKey, todayState.dateKey);
  });

  test('blocks further draws after third draw locks the state', () async {
    final games = await seedGames(localRepository);
    repository = HiveHomeRepository(
      localRepository,
      _SequenceHomeGamePicker([
        games[0].id,
        games[0].id,
        games[0].id,
      ]),
    );

    await repository.drawGame();
    await repository.drawGame();
    await repository.drawGame();

    final lockedState = await localRepository.getTodayDrawState();
    final historiesBefore = await localRepository.getPlayHistories();

    final result = await repository.drawGame();

    expect(result.type, HomeDrawResultType.locked);
    final stateAfterBlockedDraw = await localRepository.getTodayDrawState();
    expect(
      stateAfterBlockedDraw.remainingDrawCount,
      lockedState.remainingDrawCount,
    );
    expect(
      stateAfterBlockedDraw.recommendedGameId,
      lockedState.recommendedGameId,
    );

    final historiesAfter = await localRepository.getPlayHistories();
    expect(historiesAfter, hasLength(historiesBefore.length));
    expect(historiesAfter.first.gameId, historiesBefore.first.gameId);
    expect(
      historiesAfter.first.gameNameSnapshot,
      historiesBefore.first.gameNameSnapshot,
    );
  });

  test('resets draw state on the next day', () async {
    final yesterdayKey =
        buildDateKey(DateTime.now().subtract(const Duration(days: 1)));
    await localRepository.saveDailyDrawState(
      DailyDrawState(
        dateKey: yesterdayKey,
        remainingDrawCount: 0,
        isLocked: true,
        recommendedGameId: 'old-game',
        recommendedGameNameSnapshot: 'Yesterday Game',
        recommendedGameCoverImagePathSnapshot: '/sandbox/yesterday.png',
        lastDrawAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
    repository = HiveHomeRepository(
      localRepository,
      _SequenceHomeGamePicker(const <String>[]),
    );

    final todayState = await repository.getTodayDrawState();

    expect(todayState.dateKey, buildDateKey(DateTime.now()));
    expect(todayState.remainingDrawCount, 3);
    expect(todayState.isLocked, isFalse);
    expect(todayState.hasResult, isFalse);
  });
}

Future<List<Game>> seedGames(HiveAppLocalRepository localRepository) async {
  final now = DateTime(2026, 7, 1, 12);
  final games = [
    Game(
      id: 'game-1',
      name: 'Hades',
      coverImagePath: '/sandbox/hades.png',
      createdAt: now,
      updatedAt: now,
    ),
    Game(
      id: 'game-2',
      name: 'Celeste',
      coverImagePath: '/sandbox/celeste.png',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  for (final game in games) {
    await localRepository.saveGame(game);
  }

  return games;
}

class _SequenceHomeGamePicker extends HomeGamePicker {
  _SequenceHomeGamePicker(this._gameIds) : super();

  final List<String> _gameIds;
  int _index = 0;

  @override
  Game pick(List<Game> games) {
    final nextGameId = _gameIds[_index];
    _index += 1;

    for (final game in games) {
      if (game.id == nextGameId) {
        return game;
      }
    }

    throw StateError('Game not found for picker id: $nextGameId');
  }
}
