import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/app_local_repository_provider.dart';
import '../../data/repositories/hive_history_repository.dart';
import '../../domain/repositories/history_repository.dart';
import 'history_page_state.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HiveHistoryRepository(ref.watch(appLocalRepositoryProvider)),
);

final historyViewModelProvider =
    AsyncNotifierProvider<HistoryViewModel, HistoryPageState>(
  HistoryViewModel.new,
);

class HistoryViewModel extends AsyncNotifier<HistoryPageState> {
  @override
  FutureOr<HistoryPageState> build() async {
    final repository = ref.watch(historyRepositoryProvider);
    final subscription = repository.watchOverview().listen((overview) {
      state = AsyncData(HistoryPageState.fromOverview(overview));
    });
    ref.onDispose(subscription.cancel);

    final overview = await repository.getOverview();
    return HistoryPageState.fromOverview(overview);
  }
}
