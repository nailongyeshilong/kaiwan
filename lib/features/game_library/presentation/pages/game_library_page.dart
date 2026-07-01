import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/app_surface_card.dart';
import '../game_library_routes.dart';
import '../providers/game_library_view_model.dart';
import '../widgets/game_list_item.dart';

class GameLibraryPage extends ConsumerWidget {
  const GameLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameLibraryViewModelProvider);

    return AppPageScaffold(
      title: '游戏库',
      subtitle: '维护抽取卡池。新增、编辑、删除都会直接写入本地持久化存储。',
      child: state.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSurfaceCard(
                child: Row(
                  children: [
                    const Icon(AppIcons.library),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '当前游戏数',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${data.totalGames}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => context.push(GameLibraryRoutes.createPath),
                icon: const Icon(Icons.add),
                label: const Text('新增游戏'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSurfaceCard(
                child: Text(data.statusText),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (data.isEmpty)
                AppSurfaceCard(
                  child: Column(
                    children: [
                      const Icon(Icons.sports_esports_outlined, size: 48),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '当前还没有游戏',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '先新增至少 1 个游戏，首页才可以开始抽取。',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    for (var index = 0; index < data.games.length; index++) ...[
                      GameListItem(
                        game: data.games[index],
                        onEdit: () => context.push(
                          GameLibraryRoutes.editPath(data.games[index].id),
                        ),
                        onDelete: () => _confirmDeleteGame(
                          context,
                          ref,
                          data.games[index].id,
                          data.games[index].name,
                        ),
                      ),
                      if (index < data.games.length - 1)
                        const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return AppSurfaceCard(
            child: Text('游戏库加载失败：$error'),
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteGame(
    BuildContext context,
    WidgetRef ref,
    String gameId,
    String gameName,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除游戏'),
          content: Text('确定删除“$gameName”吗？已保存的历史记录不会被影响。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    try {
      await ref.read(gameLibraryViewModelProvider.notifier).deleteGame(gameId);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('游戏已删除')),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除失败：$error')),
      );
    }
  }
}
