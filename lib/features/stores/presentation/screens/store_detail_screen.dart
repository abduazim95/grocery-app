import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/features/stores/data/repositories/store_repository_impl.dart';
import 'package:grocery/shared/models/user.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/confirm_dialog.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class StoreDetailScreen extends ConsumerWidget {
  final String storeId;
  final String storeName;

  const StoreDetailScreen({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellersAsync = ref.watch(storeSellersProvider(storeId));

    return Scaffold(
      appBar: AppBar(
        title: Text(storeName),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Склад',
            onPressed: () => context.push('/stores/$storeId/stock'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSellerSheet(context, ref),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Добавить продавца'),
      ),
      body: sellersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(storeSellersProvider(storeId)),
        ),
        data: (sellers) {
          if (sellers.isEmpty) {
            return const Center(
              child: Text('Нет продавцов', style: TextStyle(color: Colors.grey)),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(storeSellersProvider(storeId)),
            child: ListView.builder(
              itemCount: sellers.length,
              itemBuilder: (_, i) => _SellerTile(
                seller: sellers[i],
                storeId: storeId,
                onChanged: () => ref.invalidate(storeSellersProvider(storeId)),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddSellerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddSellerSheet(
        storeId: storeId,
        onAdded: () => ref.invalidate(storeSellersProvider(storeId)),
      ),
    );
  }
}

class _SellerTile extends ConsumerWidget {
  final User seller;
  final String storeId;
  final VoidCallback onChanged;

  const _SellerTile({
    required this.seller,
    required this.storeId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
      title: Text(seller.name),
      subtitle: Text(seller.phone),
      trailing: PopupMenuButton<String>(
        onSelected: (v) {
          if (v == 'unlink') _unlink(context, ref);
          if (v == 'move') _showMoveSheet(context, ref);
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'move', child: Text('Перевести в другой магазин')),
          const PopupMenuItem(
            value: 'unlink',
            child: Text('Отвязать', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _unlink(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Отвязать продавца?',
      content: '${seller.name} будет отвязан от магазина и бизнеса. Аккаунт сохранится.',
      confirmText: 'Отвязать',
    );
    if (!ok) return;
    try {
      await ref.read(storeRepositoryProvider).removeSeller(
            storeId: storeId,
            sellerId: seller.id,
          );
      onChanged();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showMoveSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MoveSellerSheet(
        seller: seller,
        currentStoreId: storeId,
        onMoved: onChanged,
      ),
    );
  }
}

class _MoveSellerSheet extends ConsumerStatefulWidget {
  final User seller;
  final String currentStoreId;
  final VoidCallback onMoved;

  const _MoveSellerSheet({
    required this.seller,
    required this.currentStoreId,
    required this.onMoved,
  });

  @override
  ConsumerState<_MoveSellerSheet> createState() => _MoveSellerSheetState();
}

class _MoveSellerSheetState extends ConsumerState<_MoveSellerSheet> {
  String? _targetStoreId;
  bool _isLoading = false;

  Future<void> _move() async {
    if (_targetStoreId == null) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(storeRepositoryProvider).assignSeller(
            newStoreId: _targetStoreId!,
            sellerId: widget.seller.id,
          );
      if (mounted) {
        Navigator.pop(context);
        widget.onMoved();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.seller.name} переведён')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storesAsync = ref.watch(storesListProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Перевести ${widget.seller.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          storesAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text(mapException(e)),
            data: (stores) {
              final others = stores.where((s) => s.id != widget.currentStoreId).toList();
              return DropdownButtonFormField<String>(
                value: _targetStoreId,
                decoration: const InputDecoration(labelText: 'Новый магазин'),
                items: others
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                    .toList(),
                onChanged: (v) => setState(() => _targetStoreId = v),
              );
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading || _targetStoreId == null ? null : _move,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Перевести'),
          ),
        ],
      ),
    );
  }
}

class _AddSellerSheet extends ConsumerStatefulWidget {
  final String storeId;
  final VoidCallback onAdded;

  const _AddSellerSheet({required this.storeId, required this.onAdded});

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
    if (_nameCtrl.text.trim().isEmpty || _phoneCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(storeRepositoryProvider).addSeller(
            storeId: widget.storeId,
            name: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            password: _passCtrl.text.isEmpty ? null : _passCtrl.text,
          );
      if (mounted) {
        Navigator.pop(context);
        widget.onAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Продавец добавлен')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Добавить продавца',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Имя *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Телефон *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              helperText: 'Если продавец уже зарегистрирован — оставьте пустым',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _add,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
