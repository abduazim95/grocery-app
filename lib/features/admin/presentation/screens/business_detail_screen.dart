import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/admin/data/dtos/business_detail.dart';
import 'package:grocery/features/admin/presentation/providers/admin_provider.dart';
import 'package:grocery/shared/models/store.dart';
import 'package:grocery/shared/models/user.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class BusinessDetailScreen extends ConsumerWidget {
  final String id;
  final String name;

  const BusinessDetailScreen({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(businessDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'Добавить руководителя',
            onPressed: () async {
              await context.push(AppRoutes.newManager, extra: id);
              ref.invalidate(businessDetailProvider(id));
            },
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: mapException(e),
          onRetry: () => ref.invalidate(businessDetailProvider(id)),
        ),
        data: (detail) => _Body(detail: detail),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final BusinessDetail detail;

  const _Body({required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _Section(
          title: 'Руководители (${detail.managers.length})',
          icon: Icons.manage_accounts_outlined,
          children: detail.managers.isEmpty
              ? [const _EmptyTile('Нет руководителей')]
              : detail.managers.map((u) => _UserTile(user: u)).toList(),
        ),
        _Section(
          title: 'Продавцы (${detail.sellers.length})',
          icon: Icons.people_outline,
          children: detail.sellers.isEmpty
              ? [const _EmptyTile('Нет продавцов')]
              : detail.sellers.map((u) => _UserTile(user: u)).toList(),
        ),
        _Section(
          title: 'Магазины (${detail.stores.length})',
          icon: Icons.store_outlined,
          children: detail.stores.isEmpty
              ? [const _EmptyTile('Нет магазинов')]
              : detail.stores.map((s) => _StoreTile(store: s)).toList(),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              )),
            ],
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.person_outline),
      title: Text(user.name),
      subtitle: Text(user.phone),
      trailing: user.storeId != null
          ? const Icon(Icons.store_outlined, size: 16)
          : null,
    );
  }
}

class _StoreTile extends StatelessWidget {
  final Store store;

  const _StoreTile({required this.store});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.storefront_outlined),
      title: Text(store.name),
      subtitle: store.address?.isNotEmpty == true ? Text(store.address!) : null,
    );
  }
}

class _EmptyTile extends StatelessWidget {
  final String text;

  const _EmptyTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
