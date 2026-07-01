import '../../../../app/app_metadata.dart';
import '../../domain/entities/settings_overview.dart';
import '../../domain/repositories/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  const MockSettingsRepository();

  @override
  Future<SettingsOverview> getOverview() async {
    return const SettingsOverview(
      appName: AppMetadata.appName,
      versionLabel: AppMetadata.version,
      architectureLabel:
          'Feature First + MVVM + Repository + Riverpod + GoRouter',
      storageLabel: 'Hive CE 本地数据层已接入，后续页面会直接使用真实仓库。',
    );
  }
}
