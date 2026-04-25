import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/stores/data/repositories/store_repository_impl.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class StoresScreen extends ConsumerWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Магазины')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(AppRoutes.createStore);
          ref.invalidate(storesListProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: storesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(storesListProvider),
        ),
        data: (stores) {
          if (stores.isEmpty) {
            return const Center(child: Text('Нет магазинов'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(storesListProvider),
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (_, i) {
                final s = stores[i];
                return ListTile(
                  leading: const Icon(Icons.store_outlined),
                  title: Text(s.name),
                  subtitle: s.address != null ? Text(s.address!) : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.inventory_2_outlined),
                        tooltip: 'Склад',
                        onPressed: () => context.push('/stores/${s.id}/stock'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_add_outlined),
                        tooltip: 'Добавить продавца',
                        onPressed: () => _showAddSellerSheet(context, ref, s.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showAddSellerSheet(BuildContext context, WidgetRef ref, String storeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddSellerSheet(storeId: storeId, ref: ref),
    );
  }
}

class _AddSellerSheet extends ConsumerStatefulWidget {
  final String storeId;
  final WidgetRef ref;

  const _AddSellerSheet({required this.storeId, required this.ref});

  @override
  ConsumerState<_AddSellerSheet> createState() => _AddSellerSheetState();
}

class _AddSellerSheetState extends ConsumerState<_AddSellerSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(storeRepositoryProvider).addSeller(
            storeId: widget.storeId,
            name: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            password: _passCtrl.text,
          );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Продавец добавлен')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Добавить продавца',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Имя')),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Телефон'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Пароль'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _add,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
