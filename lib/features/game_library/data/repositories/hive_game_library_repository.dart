import '../../../../core/repositories/app_local_repository.dart';
import '../../../../core/services/game_cover_image_service.dart';
import '../../../../core/utils/app_id_generator.dart';
import '../../../../shared/models/game.dart';
import '../../domain/entities/game_library_overview.dart';
import '../../domain/repositories/game_library_repository.dart';

class HiveGameLibraryRepository implements GameLibraryRepository {
  const HiveGameLibraryRepository(
    this._localRepository,
    this._gameCoverImageService,
  );

  final AppLocalRepository _localRepository;
  final GameCoverImageService _gameCoverImageService;

  @override
  Stream<List<Game>> watchGames() => _localRepository.watchGames();

  @override
  Stream<GameLibraryOverview> watchOverview() async* {
    yield await getOverview();
    yield* watchGames().asyncMap((games) => _buildOverview(games));
  }

  @override
  Future<List<Game>> getGames() => _localRepository.getGames();

  @override
  Future<Game?> getGameById(String gameId) async {
    final games = await getGames();
    for (final game in games) {
      if (game.id == gameId) {
        return game;
      }
    }

    return null;
  }

  @override
  Future<GameLibraryOverview> getOverview() async {
    final games = await getGames();
    return _buildOverview(games);
  }

  @override
  Future<Game> createGame({
    required String name,
    required String coverImagePath,
  }) async {
    final now = DateTime.now();
    final game = Game(
      id: AppIdGenerator.newGameId(),
      name: name.trim(),
      coverImagePath: coverImagePath,
      createdAt: now,
      updatedAt: now,
    );

    await _localRepository.saveGame(game);
    return game;
  }

  @override
  Future<Game> updateGame({
    required String gameId,
    required String name,
    required String coverImagePath,
  }) async {
    final existingGame = await getGameById(gameId);
    if (existingGame == null) {
      throw StateError('Game not found: $gameId');
    }

    final updatedGame = existingGame.copyWith(
      name: name.trim(),
      coverImagePath: coverImagePath,
      updatedAt: DateTime.now(),
    );

    await _localRepository.saveGame(updatedGame);
    return updatedGame;
  }

  @override
  Future<void> deleteGame(String gameId) => _localRepository.deleteGame(gameId);

  @override
  Future<String?> pickCoverImage() {
    return _gameCoverImageService.pickAndStoreImage();
  }

  @override
  Future<bool> isGameNameTaken({
    required String name,
    String? excludingGameId,
  }) {
    return _localRepository.isGameNameTaken(
      name: name,
      excludingGameId: excludingGameId,
    );
  }

  GameLibraryOverview _buildOverview(List<Game> games) {
    return GameLibraryOverview(
      totalGames: games.length,
      statusText: games.isEmpty
          ? '当前卡池为空，请先新增至少 1 个游戏。'
          : '已接入本地持久化，新增、编辑、删除会实时同步到首页卡池。',
    );
  }
}
