import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_metadata.dart';
import '../../../../app/router/app_destination.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_surface_card.dart';
import '../../domain/entities/home_draw_result.dart';
import '../providers/home_view_model.dart';
import '../widgets/home_hero_card.dart';
import '../widgets/home_stat_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1520),
            AppColors.background,
            Color(0xFF11161E),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: state.when(
          data: (data) {
            return SingleChildScrollView(
              padding: AppSpacing.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppMetadata.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppMetadata.slogan,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HomeHeroCard(
                    title: data.featuredTitle,
                    description: data.featuredDescription,
                    coverImagePath: data.featuredCoverImagePath,
                    hasResult: data.hasResult,
                    isDrawing: data.isDrawing,
                    resultVersion: data.resultVersion,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      HomeStatCard(
                        label: '剩余抽取',
                        value: '${data.remainingDraws}/${data.maxDraws}',
                        icon: Icons.style_outlined,
                      ),
                      HomeStatCard(
                        label: '卡池游戏',
                        value: '${data.gamePoolCount}',
                        icon: Icons.grid_view_rounded,
                      ),
                      HomeStatCard(
                        label: '今日状态',
                        value: data.isLocked ? '已锁定' : '未锁定',
                        icon: Icons.shield_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: data.isDrawing
                        ? null
                        : () => _handleDrawAction(context, ref),
                    icon: data.isDrawing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.casino_outlined),
                    label: Text(data.isDrawing ? '抽取中...' : '开玩'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppSurfaceCard(
                    child: Text(
                      data.footerHint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
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
                  child: Text('首页骨架加载失败：$error'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleDrawAction(BuildContext context, WidgetRef ref) async {
    try {
      final drawResult =
          await ref.read(homeViewModelProvider.notifier).drawGame();
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(drawResult.message)),
      );

      if (drawResult.type == HomeDrawResultType.emptyPool) {
        context.go(AppDestination.gameLibrary.path);
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('抽取失败：$error')),
      );
    }
  }
}
