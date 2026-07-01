abstract final class GameLibraryRoutes {
  static const createSegment = 'new';
  static const editSegment = ':gameId/edit';

  static const createPath = '/game-library/new';

  static String editPath(String gameId) => '/game-library/$gameId/edit';
}
