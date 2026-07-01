import '../../../../shared/models/daily_draw_state.dart';
import '../entities/home_overview.dart';

abstract interface class HomeRepository {
  Stream<HomeOverview> watchOverview();

  Future<HomeOverview> getOverview();

  Future<DailyDrawState> getTodayDrawState();

  Future<void> saveDailyDrawState(DailyDrawState dailyDrawState);
}
