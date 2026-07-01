import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_local_repository.dart';
import 'hive_app_local_repository.dart';

final appLocalRepositoryProvider = Provider<AppLocalRepository>(
  (ref) => const HiveAppLocalRepository(),
);
