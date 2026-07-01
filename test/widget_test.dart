import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kaiplay/app/app.dart';
import 'package:kaiplay/features/game_library/domain/entities/game_library_overview.dart';
import 'package:kaiplay/features/game_library/domain/repositories/game_library_repository.dart';
import 'package:kaiplay/features/game_library/presentation/providers/game_library_view_model.dart';
import 'package:kaiplay/features/history/domain/entities/history_overview.dart';
import 'package:kaiplay/features/history/domain/repositories/history_repository.dart';
import 'package:kaiplay/features/history/presentation/providers/history_view_model.dart';
import 'package:kaiplay/features/home/domain/entities/home_draw_result.dart';
import 'package:kaiplay/features/home/domain/entities/home_overview.dart';
import 'package:kaiplay/features/home/domain/repositories/home_repository.dart';
import 'package:kaiplay/features/home/presentation/providers/home_view_model.dart';
import 'package:kaiplay/shared/models/daily_draw_state.dart';
import 'package:kaiplay/shared/models/game.dart';
import 'package:kaiplay/shared/models/play_history.dart';

void main() {
  testWidgets('renders bottom navigation shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(_FakeHomeRepository()),
          gameLibraryRepositoryProvider.overrideWithValue(
            _FakeGameLibraryRepository(),
          ),
          historyRepositoryProvider.overrideWithValue(_FakeHistoryRepository()),
        ],
        child: const KaiPlayApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('游戏库'), findsOneWidget);
    expect(find.text('记录'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });
}

class _FakeHomeRepository implements HomeRepository {
  @override
  Stream<HomeOverview> watchOverview() => Stream.value(getOverviewSync());

  @override
  Future<HomeOverview> getOverview() async => getOverviewSync();

  HomeOverview getOverviewSync() {
    return const HomeOverview(
      featuredTitle: '今日尚未抽取',
      featuredDescription: '测试环境首页概览。',
      featuredCoverImagePath: null,
      remainingDraws: 3,
      maxDraws: 3,
      gamePoolCount: 0,
      isLocked: false,
      hasResult: false,
      footerHint: '最多每日 3 次抽取，第 3 次后锁定今日结果。',
    );
  }

  @override
  Future<HomeDrawResult> drawGame() async {
    return const HomeDrawResult.emptyPool(
      message: '当前卡池为空，请先添加游戏。',
    );
  }

  @override
  Future<DailyDrawState> getTodayDrawState() async {
    return const DailyDrawState(
      dateKey: '2026-07-01',
      remainingDrawCount: 3,
      isLocked: false,
    );
  }

  @override
  Future<void> saveDailyDrawState(DailyDrawState dailyDrawState) async {}
}

class _FakeGameLibraryRepository implements GameLibraryRepository {
  @override
  Future<Game> createGame({
    required String name,
    required String coverImagePath,
  }) async {
    return Game(
      id: 'game-1',
      name: name,
      coverImagePath: coverImagePath,
      createdAt: DateTime(2026, 7, 1),
      updatedAt: DateTime(2026, 7, 1),
    );
  }

  @override
  Future<Game?> getGameById(String gameId) async => null;

  @override
  Stream<List<Game>> watchGames() => Stream.value(const <Game>[]);

  @override
  Stream<GameLibraryOverview> watchOverview() {
    return Stream.value(
      const GameLibraryOverview(
        totalGames: 0,
        statusText: '测试环境游戏库概览。',
      ),
    );
  }

  @override
  Future<List<Game>> getGames() async => const <Game>[];

  @override
  Future<GameLibraryOverview> getOverview() async {
    return const GameLibraryOverview(
      totalGames: 0,
      statusText: '测试环境游戏库概览。',
    );
  }

  @override
  Future<String?> pickCoverImage() async => null;

  @override
  Future<Game> updateGame({
    required String gameId,
    required String name,
    required String coverImagePath,
  }) async {
    return Game(
      id: gameId,
      name: name,
      coverImagePath: coverImagePath,
      createdAt: DateTime(2026, 7, 1),
      updatedAt: DateTime(2026, 7, 1),
    );
  }

  @override
  Future<void> deleteGame(String gameId) async {}

  @override
  Future<bool> isGameNameTaken({
    required String name,
    String? excludingGameId,
  }) async {
    return false;
  }
}

class _FakeHistoryRepository implements HistoryRepository {
  @override
  Stream<List<PlayHistory>> watchPlayHistories() {
    return Stream.value(const <PlayHistory>[]);
  }

  @override
  Stream<HistoryOverview> watchOverview() {
    return Stream.value(
      const HistoryOverview(
        totalRecords: 0,
        statusText: '测试环境历史概览。',
      ),
    );
  }

  @override
  Future<List<PlayHistory>> getPlayHistories() async => const <PlayHistory>[];

  @override
  Future<HistoryOverview> getOverview() async {
    return const HistoryOverview(
      totalRecords: 0,
      statusText: '测试环境历史概览。',
    );
  }

  @override
  Future<void> savePlayHistory(PlayHistory playHistory) async {}
}
