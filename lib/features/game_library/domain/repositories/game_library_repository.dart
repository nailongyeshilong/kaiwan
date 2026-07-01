import '../../../../shared/models/game.dart';
import '../entities/game_library_overview.dart';

abstract interface class GameLibraryRepository {
  Stream<List<Game>> watchGames();

  Stream<GameLibraryOverview> watchOverview();

  Future<List<Game>> getGames();

  Future<Game?> getGameById(String gameId);

  Future<GameLibraryOverview> getOverview();

  Future<Game> createGame({
    required String name,
    required String coverImagePath,
  });

  Future<Game> updateGame({
    required String gameId,
    required String name,
    required String coverImagePath,
  });

  Future<void> deleteGame(String gameId);

  Future<String?> pickCoverImage();

  Future<bool> isGameNameTaken({
    required String name,
    String? excludingGameId,
  });
}
