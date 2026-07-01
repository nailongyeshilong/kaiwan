import '../../../../shared/models/play_history.dart';
import '../entities/history_overview.dart';

abstract interface class HistoryRepository {
  Stream<List<PlayHistory>> watchPlayHistories();

  Stream<HistoryOverview> watchOverview();

  Future<List<PlayHistory>> getPlayHistories();

  Future<HistoryOverview> getOverview();

  Future<void> savePlayHistory(PlayHistory playHistory);
}
