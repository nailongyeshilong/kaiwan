import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class GameCoverPreview extends StatelessWidget {
  const GameCoverPreview({
    super.key,
    required this.coverImagePath,
    this.height = 180,
  });

  final String? coverImagePath;
  final double height;

  @override
  Widget build(BuildContext context) {
    final resolvedPath = coverImagePath;
    final hasImage = resolvedPath != null && File(resolvedPath).existsSync();

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.divider),
      ),
      child: hasImage
          ? ClipRRect(
              borderRadius: AppRadius.card,
              child: Image.file(
                File(resolvedPath),
                fit: BoxFit.cover,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_outlined, size: 40),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '请选择游戏封面',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
    );
  }
}
