import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:kaiplay/core/repositories/hive_app_local_repository.dart';
import 'package:kaiplay/core/services/game_cover_image_service.dart';
import 'package:kaiplay/core/storage/hive_storage_initializer.dart';
import 'package:kaiplay/features/game_library/data/repositories/hive_game_library_repository.dart';

void main() {
  late Directory tempDirectory;
  late HiveGameLibraryRepository repository;

  setUp(() async {
    tempDirectory =
        await Directory.systemTemp.createTemp('kaiplay_game_library_test_');
    await HiveStorageInitializer.resetForTest();
    await HiveStorageInitializer.initializeWithPath(tempDirectory.path);
    repository = HiveGameLibraryRepository(
      const HiveAppLocalRepository(),
      _FakeGameCoverImageService(),
    );
  });

  tearDown(() async {
    await HiveStorageInitializer.resetForTest();
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('creates, updates, validates, and deletes games', () async {
    final createdGame = await repository.createGame(
      name: 'Hades',
      coverImagePath: '/sandbox/hades.png',
    );

    expect(createdGame.name, 'Hades');

    final createdGames = await repository.getGames();
    expect(createdGames, hasLength(1));
    expect(createdGames.first.coverImagePath, '/sandbox/hades.png');

    final duplicateNameTaken = await repository.isGameNameTaken(name: 'hades');
    expect(duplicateNameTaken, isTrue);

    final updatedGame = await repository.updateGame(
      gameId: createdGame.id,
      name: 'Hades II',
      coverImagePath: '/sandbox/hades-2.png',
    );

    expect(updatedGame.name, 'Hades II');
    expect(updatedGame.coverImagePath, '/sandbox/hades-2.png');

    final reloadedGame = await repository.getGameById(createdGame.id);
    expect(reloadedGame, isNotNull);
    expect(reloadedGame!.name, 'Hades II');

    final duplicateWhenEditingSameGame = await repository.isGameNameTaken(
      name: 'Hades II',
      excludingGameId: createdGame.id,
    );
    expect(duplicateWhenEditingSameGame, isFalse);

    await repository.deleteGame(createdGame.id);

    final gamesAfterDelete = await repository.getGames();
    expect(gamesAfterDelete, isEmpty);
  });

  test('returns persisted sandbox path from cover picker service', () async {
    final pickedImagePath = await repository.pickCoverImage();

    expect(pickedImagePath, '/sandbox/picked-cover.png');
  });
}

class _FakeGameCoverImageService extends GameCoverImageService {
  _FakeGameCoverImageService()
      : super(
          picker: _UnusedGameCoverImagePicker(),
          storage: _UnusedGameCoverImageStorage(),
        );

  @override
  Future<String?> pickAndStoreImage() async {
    return '/sandbox/picked-cover.png';
  }
}

class _UnusedGameCoverImagePicker implements GameCoverImagePicker {
  @override
  Future<XFile?> pickImage() => throw UnimplementedError();
}

class _UnusedGameCoverImageStorage implements GameCoverImageStorage {
  @override
  Future<String> storeImage(XFile imageFile) => throw UnimplementedError();
}
