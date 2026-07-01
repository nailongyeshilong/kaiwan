import '../../../../shared/models/daily_draw_state.dart';
import '../entities/home_draw_result.dart';
import '../entities/home_overview.dart';

abstract interface class HomeRepository {
  Stream<HomeOverview> watchOverview();

  Future<HomeOverview> getOverview();

  Future<HomeDrawResult> drawGame();

  Future<DailyDrawState> getTodayDrawState();

  Future<void> saveDailyDrawState(DailyDrawState dailyDrawState);
}
