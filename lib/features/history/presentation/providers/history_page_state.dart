import '../../domain/entities/history_overview.dart';

class HistoryPageState {
  const HistoryPageState({
    required this.totalRecords,
    required this.statusText,
  });

  factory HistoryPageState.fromOverview(HistoryOverview overview) {
    return HistoryPageState(
      totalRecords: overview.totalRecords,
      statusText: overview.statusText,
    );
  }

  final int totalRecords;
  final String statusText;
}
