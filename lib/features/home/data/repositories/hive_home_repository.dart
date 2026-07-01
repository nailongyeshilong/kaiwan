import 'dart:async';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/repositories/app_local_repository.dart';
import '../../../../core/utils/app_id_generator.dart';
import '../../../../shared/models/daily_draw_state.dart';
import '../../../../shared/models/game.dart';
import '../../../../shared/models/play_history.dart';
import '../services/home_game_picker.dart';
import '../../domain/entities/home_draw_result.dart';
import '../../domain/entities/home_overview.dart';
import '../../domain/repositories/home_repository.dart';

class HiveHomeRepository implements HomeRepository {
  const HiveHomeRepository(
    this._localRepository,
    this._gamePicker,
  );

  final AppLocalRepository _localRepository;
  final HomeGamePicker _gamePicker;

  @override
  Stream<HomeOverview> watchOverview() {
    final controller = StreamController<HomeOverview>();

    Future<void> emitOverview() async {
      try {
        controller.add(await getOverview());
      } catch (error, stackTrace) {
        controller.addError(error, stackTrace);
      }
    }

    unawaited(emitOverview());
    final gameSubscription = _localRepository.watchGames().listen((_) {
      unawaited(emitOverview());
    });
    final dailyStateSubscription =
        _localRepository.watchTodayDrawState().listen(
      (_) {
        unawaited(emitOverview());
      },
    );

    controller.onCancel = () async {
      await gameSubscription.cancel();
      await dailyStateSubscription.cancel();
    };

    return controller.stream;
  }

  @override
  Future<HomeOverview> getOverview() async {
    final games = await _localRepository.getGames();
    final dailyDrawState = await getTodayDrawState();
    final featuredTitle = dailyDrawState.recommendedGameNameSnapshot ??
        (games.isEmpty ? '当前卡池为空' : '今日尚未抽取');

    return HomeOverview(
      featuredTitle: featuredTitle,
      featuredDescription: _buildFeaturedDescription(
        games: games,
        dailyDrawState: dailyDrawState,
      ),
      featuredCoverImagePath:
          dailyDrawState.recommendedGameCoverImagePathSnapshot,
      remainingDraws: dailyDrawState.remainingDrawCount,
      maxDraws: AppConstants.maxDailyDrawCount,
      gamePoolCount: games.length,
      isLocked: dailyDrawState.isLocked,
      hasResult: dailyDrawState.hasResult,
      footerHint: '最多每日 3 次抽取，第 3 次后锁定今日结果。',
    );
  }

  @override
  Future<HomeDrawResult> drawGame() async {
    final games = await _localRepository.getGames();
    if (games.isEmpty) {
      return const HomeDrawResult.emptyPool(
        message: '当前卡池为空，请先添加游戏。',
      );
    }

    final dailyDrawState = await getTodayDrawState();
    if (dailyDrawState.isLocked || dailyDrawState.remainingDrawCount <= 0) {
      return const HomeDrawResult.locked(
        message: '今日抽取次数已用完，请明天再来。',
      );
    }

    final pickedGame = _gamePicker.pick(games);
    final drawnAt = DateTime.now();
    final remainingDraws = dailyDrawState.remainingDrawCount - 1;
    final isLocked = remainingDraws <= 0;

    final updatedDailyDrawState = dailyDrawState.copyWith(
      remainingDrawCount: remainingDraws,
      isLocked: isLocked,
      recommendedGameId: pickedGame.id,
      recommendedGameNameSnapshot: pickedGame.name,
      recommendedGameCoverImagePathSnapshot: pickedGame.coverImagePath,
      lastDrawAt: drawnAt,
    );

    await saveDailyDrawState(updatedDailyDrawState);

    if (isLocked) {
      await _localRepository.savePlayHistory(
        PlayHistory(
          id: AppIdGenerator.newPlayHistoryId(),
          dateKey: updatedDailyDrawState.dateKey,
          gameId: pickedGame.id,
          gameNameSnapshot: pickedGame.name,
          gameCoverImagePathSnapshot: pickedGame.coverImagePath,
          drawnAt: drawnAt,
        ),
      );

      return HomeDrawResult.success(
        message: '今日最终结果已锁定：${pickedGame.name}',
      );
    }

    return HomeDrawResult.success(
      message: '抽取完成：${pickedGame.name}',
    );
  }

  @override
  Future<DailyDrawState> getTodayDrawState() =>
      _localRepository.getTodayDrawState();

  @override
  Future<void> saveDailyDrawState(DailyDrawState dailyDrawState) =>
      _localRepository.saveDailyDrawState(dailyDrawState);

  String _buildFeaturedDescription({
    required List<Game> games,
    required DailyDrawState dailyDrawState,
  }) {
    if (dailyDrawState.hasResult) {
      return dailyDrawState.isLocked
          ? '今日结果已锁定，历史记录会保留当前游戏快照。'
          : '今日结果已保存，可继续重新抽取直到第 3 次锁定。';
    }

    if (games.isEmpty) {
      return '当前卡池为空，请先前往游戏库添加至少 1 个游戏。';
    }

    return '今天还有 3 次机会，点击“开玩”开始抽取今日游戏。';
  }
}
