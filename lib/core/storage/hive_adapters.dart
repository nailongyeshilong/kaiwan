import 'package:hive_ce/hive_ce.dart';

import 'models/daily_draw_state_storage_model.dart';
import 'models/game_storage_model.dart';
import 'models/play_history_storage_model.dart';

@GenerateAdapters([
  AdapterSpec<GameStorageModel>(),
  AdapterSpec<DailyDrawStateStorageModel>(),
  AdapterSpec<PlayHistoryStorageModel>(),
])
part 'hive_adapters.g.dart';
