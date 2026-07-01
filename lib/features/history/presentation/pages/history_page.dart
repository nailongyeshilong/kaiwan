import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/app_surface_card.dart';
import '../providers/history_view_model.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyViewModelProvider);

    return AppPageScaffold(
      title: '游玩记录',
      subtitle: '只读展示每日最终锁定结果。当前阶段先接入一级页面和状态骨架。',
      child: state.when(
        data: (data) {
          return Column(
            children: [
              AppSurfaceCard(
                child: Row(
                  children: [
                    const Icon(AppIcons.history),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '累计记录',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${data.totalRecords}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSurfaceCard(
                child: Text(data.statusText),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return AppSurfaceCard(
            child: Text('记录页骨架加载失败：$error'),
          );
        },
      ),
    );
  }
}
