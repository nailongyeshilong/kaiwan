import 'dart:async';

import '../../../../core/repositories/app_local_repository.dart';
import '../../../../shared/models/daily_draw_state.dart';
import '../../../../shared/models/game.dart';
import '../../domain/entities/home_overview.dart';
import '../../domain/repositories/home_repository.dart';

class HiveHomeRepository implements HomeRepository {
  const HiveHomeRepository(this._localRepository);

  final AppLocalRepository _localRepository;

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
      remainingDraws: dailyDrawState.remainingDrawCount,
      maxDraws: 3,
      gamePoolCount: games.length,
      isLocked: dailyDrawState.isLocked,
      footerHint: '最多每日 3 次抽取，第 3 次后锁定今日结果。',
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

    return '本地数据层已接通，后续抽取结果会在这里持久化展示。';
  }
}
