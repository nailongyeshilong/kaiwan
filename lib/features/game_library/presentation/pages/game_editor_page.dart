import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_surface_card.dart';
import '../providers/game_editor_controller.dart';
import '../widgets/game_cover_preview.dart';

class GameEditorPage extends ConsumerStatefulWidget {
  const GameEditorPage({
    super.key,
    this.gameId,
  });

  final String? gameId;

  @override
  ConsumerState<GameEditorPage> createState() => _GameEditorPageState();
}

class _GameEditorPageState extends ConsumerState<GameEditorPage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(gameEditorControllerProvider(widget.gameId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameId == null ? '新增游戏' : '编辑游戏'),
      ),
      body: SafeArea(
        child: asyncState.when(
          data: (state) {
            if (_nameController.text != state.name) {
              _nameController.value = _nameController.value.copyWith(
                text: state.name,
                selection: TextSelection.collapsed(offset: state.name.length),
              );
            }

            return SingleChildScrollView(
              padding: AppSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    state.pageTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '选择封面后会立即复制到应用沙盒，数据库只保存本地路径。',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  GameCoverPreview(coverImagePath: state.coverImagePath),
                  if (state.coverErrorText != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.coverErrorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: state.isSubmitting ? null : _pickCoverImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      state.coverImagePath == null ? '选择封面' : '重新选择封面',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TextField(
                    controller: _nameController,
                    onChanged: ref
                        .read(gameEditorControllerProvider(widget.gameId)
                            .notifier)
                        .updateName,
                    decoration: InputDecoration(
                      labelText: '游戏名称',
                      hintText: '请输入游戏名称',
                      errorText: state.nameErrorText,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: state.isSubmitting ? null : _submit,
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(state.submitButtonText),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppSurfaceCard(
                    child: Text(
                      state.isEditMode
                          ? '编辑后，游戏库列表和首页卡池会立即使用最新数据。'
                          : '保存成功后，游戏会立即出现在游戏库并同步到首页卡池。',
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            return Center(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: AppSurfaceCard(
                  child: Text('游戏编辑页加载失败：$error'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickCoverImage() async {
    try {
      await ref
          .read(gameEditorControllerProvider(widget.gameId).notifier)
          .pickCoverImage();
      if (!mounted) {
        return;
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择封面失败：$error')),
      );
    }
  }

  Future<void> _submit() async {
    try {
      final isSuccess = await ref
          .read(gameEditorControllerProvider(widget.gameId).notifier)
          .submit();

      if (!mounted || !isSuccess) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.gameId == null ? '游戏已保存' : '游戏已更新'),
        ),
      );
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败：$error')),
      );
    }
  }
}
