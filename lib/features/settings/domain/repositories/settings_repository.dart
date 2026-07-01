import '../entities/settings_overview.dart';

abstract interface class SettingsRepository {
  Future<SettingsOverview> getOverview();
}
