import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/app_local_repository_provider.dart';
import '../../data/repositories/hive_home_repository.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_page_state.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HiveHomeRepository(ref.watch(appLocalRepositoryProvider)),
);

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, HomePageState>(
  HomeViewModel.new,
);

class HomeViewModel extends AsyncNotifier<HomePageState> {
  @override
  FutureOr<HomePageState> build() async {
    final repository = ref.watch(homeRepositoryProvider);
    final subscription = repository.watchOverview().listen((overview) {
      state = AsyncData(HomePageState.fromOverview(overview));
    });
    ref.onDispose(subscription.cancel);

    final overview = await repository.getOverview();
    return HomePageState.fromOverview(overview);
  }
}
