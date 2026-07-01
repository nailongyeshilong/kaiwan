import 'package:hive_ce/hive_ce.dart';

import 'hive_box_names.dart';
import 'models/daily_draw_state_storage_model.dart';
import 'models/game_storage_model.dart';
import 'models/play_history_storage_model.dart';

abstract final class HiveBoxes {
  static Box<GameStorageModel> get games =>
      Hive.box<GameStorageModel>(HiveBoxNames.games);

  static Box<DailyDrawStateStorageModel> get dailyDrawStates =>
      Hive.box<DailyDrawStateStorageModel>(HiveBoxNames.dailyDrawStates);

  static Box<PlayHistoryStorageModel> get playHistories =>
      Hive.box<PlayHistoryStorageModel>(HiveBoxNames.playHistories);
}
