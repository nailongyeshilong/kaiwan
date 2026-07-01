import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_library_view_model.dart';
import 'game_editor_state.dart';

final gameEditorControllerProvider = AutoDisposeAsyncNotifierProviderFamily<
    GameEditorController, GameEditorState, String?>(
  GameEditorController.new,
);

class GameEditorController
    extends AutoDisposeFamilyAsyncNotifier<GameEditorState, String?> {
  @override
  FutureOr<GameEditorState> build(String? arg) async {
    final repository = ref.read(gameLibraryRepositoryProvider);

    if (arg == null) {
      return GameEditorState.create();
    }

    final game = await repository.getGameById(arg);
    if (game == null) {
      throw StateError('Game not found: $arg');
    }

    return GameEditorState.edit(
      gameId: game.id,
      name: game.name,
      coverImagePath: game.coverImagePath,
    );
  }

  void updateName(String value) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      currentState.copyWith(
        name: value,
        clearNameError: true,
      ),
    );
  }

  Future<void> pickCoverImage() async {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    final repository = ref.read(gameLibraryRepositoryProvider);
    final storedImagePath = await repository.pickCoverImage();
    if (storedImagePath == null) {
      return;
    }

    state = AsyncData(
      currentState.copyWith(
        coverImagePath: storedImagePath,
        clearCoverError: true,
      ),
    );
  }

  Future<bool> submit() async {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return false;
    }

    final normalizedName = currentState.name.trim();
    final hasName = normalizedName.isNotEmpty;
    final hasCover = currentState.coverImagePath != null;

    if (!hasName || !hasCover) {
      state = AsyncData(
        currentState.copyWith(
          nameErrorText: hasName ? null : '请输入游戏名称',
          coverErrorText: hasCover ? null : '请选择游戏封面',
        ),
      );
      return false;
    }

    final repository = ref.read(gameLibraryRepositoryProvider);
    final isNameTaken = await repository.isGameNameTaken(
      name: normalizedName,
      excludingGameId: currentState.gameId,
    );
    if (isNameTaken) {
      state = AsyncData(
        currentState.copyWith(
          nameErrorText: '游戏名称已存在，请使用其他名称',
          clearCoverError: true,
        ),
      );
      return false;
    }

    state = AsyncData(
      currentState.copyWith(
        isSubmitting: true,
        clearNameError: true,
        clearCoverError: true,
      ),
    );

    try {
      if (currentState.isEditMode) {
        await repository.updateGame(
          gameId: currentState.gameId!,
          name: normalizedName,
          coverImagePath: currentState.coverImagePath!,
        );
      } else {
        await repository.createGame(
          name: normalizedName,
          coverImagePath: currentState.coverImagePath!,
        );
      }

      return true;
    } finally {
      final latestState = state.valueOrNull ?? currentState;
      state = AsyncData(latestState.copyWith(isSubmitting: false));
    }
  }
}
