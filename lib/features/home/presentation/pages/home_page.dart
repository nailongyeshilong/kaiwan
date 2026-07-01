import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_metadata.dart';
import '../../../../app/router/app_destination.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_surface_card.dart';
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
                  FilledButton(
                    onPressed: () =>
                        _handleDrawAction(context, data.gamePoolCount),
                    child: const Text('开玩'),
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

  void _handleDrawAction(BuildContext context, int gamePoolCount) {
    if (gamePoolCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前卡池为空，请先添加游戏。')),
      );
      context.go(AppDestination.gameLibrary.path);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('抽取流程将在后续步骤接入。')),
    );
  }
}
