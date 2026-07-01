class GameEditorState {
  const GameEditorState({
    required this.gameId,
    required this.name,
    required this.coverImagePath,
    required this.isEditMode,
    this.nameErrorText,
    this.coverErrorText,
    this.isSubmitting = false,
  });

  factory GameEditorState.create() {
    return const GameEditorState(
      gameId: null,
      name: '',
      coverImagePath: null,
      isEditMode: false,
    );
  }

  factory GameEditorState.edit({
    required String gameId,
    required String name,
    required String coverImagePath,
  }) {
    return GameEditorState(
      gameId: gameId,
      name: name,
      coverImagePath: coverImagePath,
      isEditMode: true,
    );
  }

  final String? gameId;
  final String name;
  final String? coverImagePath;
  final bool isEditMode;
  final String? nameErrorText;
  final String? coverErrorText;
  final bool isSubmitting;

  String get pageTitle => isEditMode ? '编辑游戏' : '新增游戏';

  String get submitButtonText => isEditMode ? '保存修改' : '保存游戏';

  GameEditorState copyWith({
    String? gameId,
    String? name,
    String? coverImagePath,
    bool? isEditMode,
    String? nameErrorText,
    String? coverErrorText,
    bool? isSubmitting,
    bool clearNameError = false,
    bool clearCoverError = false,
  }) {
    return GameEditorState(
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      isEditMode: isEditMode ?? this.isEditMode,
      nameErrorText:
          clearNameError ? null : nameErrorText ?? this.nameErrorText,
      coverErrorText:
          clearCoverError ? null : coverErrorText ?? this.coverErrorText,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
