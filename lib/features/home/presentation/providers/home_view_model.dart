import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/app_local_repository_provider.dart';
import '../../data/services/home_game_picker.dart';
import '../../data/repositories/hive_home_repository.dart';
import '../../domain/entities/home_draw_result.dart';
import '../../domain/entities/home_overview.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_page_state.dart';

final homeGamePickerProvider = Provider<HomeGamePicker>(
  (ref) => HomeGamePicker(),
);

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HiveHomeRepository(
    ref.watch(appLocalRepositoryProvider),
    ref.watch(homeGamePickerProvider),
  ),
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
      final previousState = state.valueOrNull;
      state = AsyncData(_mapOverview(overview, previousState));
    });
    ref.onDispose(subscription.cancel);

    final overview = await repository.getOverview();
    return HomePageState.fromOverview(overview);
  }

  Future<HomeDrawResult> drawGame() async {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return const HomeDrawResult.busy(message: '首页正在初始化，请稍候。');
    }

    if (currentState.isDrawing) {
      return const HomeDrawResult.busy(message: '正在抽取中，请稍候。');
    }

    state = AsyncData(currentState.copyWith(isDrawing: true));

    try {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      final result = await ref.read(homeRepositoryProvider).drawGame();
      final latestOverview =
          await ref.read(homeRepositoryProvider).getOverview();
      state = AsyncData(
        _mapOverview(
          latestOverview,
          state.valueOrNull ?? currentState,
          isDrawing: false,
          incrementResultVersion: result.isSuccess,
        ),
      );
      return result;
    } catch (error, stackTrace) {
      state = AsyncData(currentState.copyWith(isDrawing: false));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  HomePageState _mapOverview(
    HomeOverview overview,
    HomePageState? previousState, {
    bool? isDrawing,
    bool incrementResultVersion = false,
  }) {
    final baseState = HomePageState.fromOverview(overview);
    final previousVersion = previousState?.resultVersion ?? 0;

    return baseState.copyWith(
      isDrawing: isDrawing ?? previousState?.isDrawing ?? false,
      resultVersion:
          incrementResultVersion ? previousVersion + 1 : previousVersion,
    );
  }
}
