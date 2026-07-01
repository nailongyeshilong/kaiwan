import '../../../../core/repositories/app_local_repository.dart';
import '../../../../shared/models/play_history.dart';
import '../../domain/entities/history_overview.dart';
import '../../domain/repositories/history_repository.dart';

class HiveHistoryRepository implements HistoryRepository {
  const HiveHistoryRepository(this._localRepository);

  final AppLocalRepository _localRepository;

  @override
  Stream<List<PlayHistory>> watchPlayHistories() =>
      _localRepository.watchPlayHistories();

  @override
  Stream<HistoryOverview> watchOverview() async* {
    yield await getOverview();
    yield* watchPlayHistories().asyncMap((histories) => HistoryOverview(
          totalRecords: histories.length,
          statusText: histories.isEmpty
              ? '当前还没有历史记录，第 3 次最终抽取结果会写入本地历史。'
              : '历史记录已通过 Hive 本地持久化，后续删除游戏也不会丢失快照。',
        ));
  }

  @override
  Future<List<PlayHistory>> getPlayHistories() =>
      _localRepository.getPlayHistories();

  @override
  Future<HistoryOverview> getOverview() async {
    final histories = await getPlayHistories();
    return HistoryOverview(
      totalRecords: histories.length,
      statusText: histories.isEmpty
          ? '当前还没有历史记录，第 3 次最终抽取结果会写入本地历史。'
          : '历史记录已通过 Hive 本地持久化，后续删除游戏也不会丢失快照。',
    );
  }

  @override
  Future<void> savePlayHistory(PlayHistory playHistory) =>
      _localRepository.savePlayHistory(playHistory);
}
