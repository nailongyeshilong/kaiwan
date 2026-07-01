import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_surface_card.dart';

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({
    super.key,
    required this.title,
    required this.description,
    required this.coverImagePath,
    required this.hasResult,
    required this.isDrawing,
    required this.resultVersion,
  });

  final String title;
  final String description;
  final String? coverImagePath;
  final bool hasResult;
  final bool isDrawing;
  final int resultVersion;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppRadius.card,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          height: 340,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDrawing
                  ? const [
                      Color(0xFF33506E),
                      Color(0xFF132232),
                    ]
                  : const [
                      Color(0xFF223449),
                      Color(0xFF101722),
                    ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasResult &&
                  coverImagePath != null &&
                  coverImagePath!.isNotEmpty)
                Positioned.fill(
                  child: Image.file(
                    File(coverImagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(
                          alpha: hasResult ? 0.18 : 0.0,
                        ),
                        Colors.black.withValues(alpha: 0.68),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isDrawing
                              ? AppColors.primaryContainer
                              : AppColors.secondary,
                          borderRadius: BorderRadius.circular(AppSpacing.xl),
                          border: Border.all(color: AppColors.primaryContainer),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDrawing ? Icons.bolt_rounded : AppIcons.star,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              isDrawing ? '正在抽取' : '今日推荐',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: isDrawing
                            ? const SizedBox(
                                key: ValueKey('drawing-indicator'),
                                width: 72,
                                height: 72,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                ),
                              )
                            : const Icon(
                                AppIcons.game,
                                key: ValueKey('game-icon'),
                                size: 72,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 320),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: Column(
                          key: ValueKey(resultVersion),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
