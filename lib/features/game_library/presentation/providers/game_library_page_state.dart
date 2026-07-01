import '../../../../shared/models/game.dart';

class GameLibraryPageState {
  const GameLibraryPageState({
    required this.games,
    required this.statusText,
  });

  factory GameLibraryPageState.fromGames(List<Game> games) {
    return GameLibraryPageState(
      games: List<Game>.unmodifiable(games),
      statusText: games.isEmpty
          ? '当前卡池为空，请先新增至少 1 个游戏。'
          : '已接入本地持久化，新增、编辑、删除会实时同步到首页卡池。',
    );
  }

  final List<Game> games;
  final String statusText;

  int get totalGames => games.length;

  bool get isEmpty => games.isEmpty;
}
