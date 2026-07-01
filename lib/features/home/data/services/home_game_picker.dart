import 'dart:math';

import '../../../../shared/models/game.dart';

class HomeGamePicker {
  HomeGamePicker({
    Random? random,
  }) : _random = random ?? Random();

  final Random _random;

  Game pick(List<Game> games) {
    if (games.isEmpty) {
      throw ArgumentError.value(games, 'games', 'Game pool cannot be empty.');
    }

    return games[_random.nextInt(games.length)];
  }
}
