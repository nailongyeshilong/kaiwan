import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../utils/app_id_generator.dart';

abstract interface class GameCoverImagePicker {
  Future<XFile?> pickImage();
}

class DeviceGameCoverImagePicker implements GameCoverImagePicker {
  DeviceGameCoverImagePicker({
    ImagePicker? imagePicker,
  }) : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<XFile?> pickImage() {
    return _imagePicker.pickImage(source: ImageSource.gallery);
  }
}

abstract interface class GameCoverImageStorage {
  Future<String> storeImage(XFile imageFile);
}

class AppGameCoverImageStorage implements GameCoverImageStorage {
  @override
  Future<String> storeImage(XFile imageFile) async {
    final applicationDirectory = await getApplicationDocumentsDirectory();
    final gameCoverDirectory = Directory(
      path.join(applicationDirectory.path, 'game_covers'),
    );

    if (!await gameCoverDirectory.exists()) {
      await gameCoverDirectory.create(recursive: true);
    }

    final imageExtension = path.extension(imageFile.path);
    final storedFilePath = path.join(
      gameCoverDirectory.path,
      '${AppIdGenerator.newFileId()}$imageExtension',
    );

    await imageFile.saveTo(storedFilePath);
    return storedFilePath;
  }
}

class GameCoverImageService {
  const GameCoverImageService({
    required GameCoverImagePicker picker,
    required GameCoverImageStorage storage,
  })  : _picker = picker,
        _storage = storage;

  final GameCoverImagePicker _picker;
  final GameCoverImageStorage _storage;

  Future<String?> pickAndStoreImage() async {
    final pickedImage = await _picker.pickImage();
    if (pickedImage == null) {
      return null;
    }

    return _storage.storeImage(pickedImage);
  }
}
