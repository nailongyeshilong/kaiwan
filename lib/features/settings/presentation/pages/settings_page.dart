import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/app_surface_card.dart';
import '../providers/settings_view_model.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);

    return AppPageScaffold(
      title: '设置',
      subtitle: 'Sprint 01 中先保留应用信息入口，后续再接入真实版本读取。',
      child: state.when(
        data: (data) {
          return Column(
            children: [
              AppSurfaceCard(
                child: Row(
                  children: [
                    const Icon(AppIcons.version),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.appName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '版本 ${data.versionLabel}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前架构',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(data.architectureLabel),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSurfaceCard(
                child: Text(data.storageLabel),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return AppSurfaceCard(
            child: Text('设置页骨架加载失败：$error'),
          );
        },
      ),
    );
  }
}
