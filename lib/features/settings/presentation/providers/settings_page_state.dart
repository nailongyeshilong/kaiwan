import '../../domain/entities/settings_overview.dart';

class SettingsPageState {
  const SettingsPageState({
    required this.appName,
    required this.versionLabel,
    required this.architectureLabel,
    required this.storageLabel,
  });

  factory SettingsPageState.fromOverview(SettingsOverview overview) {
    return SettingsPageState(
      appName: overview.appName,
      versionLabel: overview.versionLabel,
      architectureLabel: overview.architectureLabel,
      storageLabel: overview.storageLabel,
    );
  }

  final String appName;
  final String versionLabel;
  final String architectureLabel;
  final String storageLabel;
}
