import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/admin/presentation/providers/admin_provider.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class BusinessListScreen extends ConsumerWidget {
  const BusinessListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(businessesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Бизнесы')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: mapException(e),
          onRetry: () => ref.invalidate(businessesProvider),
        ),
        data: (businesses) {
          if (businesses.isEmpty) {
            return const Center(child: Text('Нет бизнесов'));
          }
          return ListView.separated(
            itemCount: businesses.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final b = businesses[i];
              return ListTile(
                leading: const Icon(Icons.business_outlined),
                title: Text(b.name),
                subtitle: Text('Создан ${formatDate(b.createdAt)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(
                  AppRoutes.adminBusiness(b.id),
                  extra: b.name,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRoutes.newBusiness);
          ref.invalidate(businessesProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Новый бизнес'),
      ),
    );
  }
}
