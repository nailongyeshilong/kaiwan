import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

import '../logger/app_logger.dart';
import 'hive_box_names.dart';
import 'hive_registrar.g.dart';
import 'models/daily_draw_state_storage_model.dart';
import 'models/game_storage_model.dart';
import 'models/play_history_storage_model.dart';

abstract final class HiveStorageInitializer {
  static bool _adaptersRegistered = false;
  static String? _initializedPath;

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    final applicationDirectory = await getApplicationDocumentsDirectory();
    await initializeWithPath(applicationDirectory.path);
  }

  static Future<void> initializeWithPath(String path) async {
    if (_initializedPath != path) {
      if (_initializedPath != null) {
        await Hive.close();
      }

      Hive.init(path);
      _initializedPath = path;
      AppLogger.info('Hive initialized at $path', scope: 'HiveStorage');
    }

    if (!_adaptersRegistered) {
      Hive.registerAdapters();
      _adaptersRegistered = true;
    }

    await _openBoxes();
  }

  static Future<void> resetForTest() async {
    await Hive.close();
    _initializedPath = null;
  }

  static Future<void> _openBoxes() async {
    if (!Hive.isBoxOpen(HiveBoxNames.games)) {
      await Hive.openBox<GameStorageModel>(HiveBoxNames.games);
    }

    if (!Hive.isBoxOpen(HiveBoxNames.dailyDrawStates)) {
      await Hive.openBox<DailyDrawStateStorageModel>(
        HiveBoxNames.dailyDrawStates,
      );
    }

    if (!Hive.isBoxOpen(HiveBoxNames.playHistories)) {
      await Hive.openBox<PlayHistoryStorageModel>(HiveBoxNames.playHistories);
    }
  }
}
