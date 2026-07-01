import 'package:uuid/uuid.dart';

abstract final class AppIdGenerator {
  static const Uuid _uuid = Uuid();

  static String newFileId() => _uuid.v4();

  static String newGameId() => _uuid.v4();

  static String newPlayHistoryId() => _uuid.v4();
}
