import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/app_local_repository_provider.dart';
import '../../../../core/services/game_cover_image_service.dart';
import '../../data/repositories/hive_game_library_repository.dart';
import '../../domain/repositories/game_library_repository.dart';
import 'game_library_page_state.dart';

final gameCoverImageServiceProvider = Provider<GameCoverImageService>(
  (ref) => GameCoverImageService(
    picker: DeviceGameCoverImagePicker(),
    storage: AppGameCoverImageStorage(),
  ),
);

final gameLibraryRepositoryProvider = Provider<GameLibraryRepository>(
  (ref) => HiveGameLibraryRepository(
    ref.watch(appLocalRepositoryProvider),
    ref.watch(gameCoverImageServiceProvider),
  ),
);

final gameLibraryViewModelProvider =
    AsyncNotifierProvider<GameLibraryViewModel, GameLibraryPageState>(
  GameLibraryViewModel.new,
);

class GameLibraryViewModel extends AsyncNotifier<GameLibraryPageState> {
  @override
  FutureOr<GameLibraryPageState> build() async {
    final repository = ref.watch(gameLibraryRepositoryProvider);
    final subscription = repository.watchGames().listen((games) {
      state = AsyncData(GameLibraryPageState.fromGames(games));
    });
    ref.onDispose(subscription.cancel);

    final games = await repository.getGames();
    return GameLibraryPageState.fromGames(games);
  }

  Future<void> deleteGame(String gameId) async {
    final repository = ref.read(gameLibraryRepositoryProvider);
    await repository.deleteGame(gameId);
  }
}
