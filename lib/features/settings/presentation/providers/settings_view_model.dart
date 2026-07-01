import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_settings_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_page_state.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => const MockSettingsRepository(),
);

final settingsViewModelProvider =
    AsyncNotifierProvider<SettingsViewModel, SettingsPageState>(
  SettingsViewModel.new,
);

class SettingsViewModel extends AsyncNotifier<SettingsPageState> {
  @override
  FutureOr<SettingsPageState> build() async {
    final repository = ref.watch(settingsRepositoryProvider);
    final overview = await repository.getOverview();
    return SettingsPageState.fromOverview(overview);
  }
}
