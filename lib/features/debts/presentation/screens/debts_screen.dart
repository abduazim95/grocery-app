import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/debts/presentation/providers/debts_provider.dart';
import 'package:grocery/features/stores/data/repositories/store_repository_impl.dart';
import 'package:grocery/shared/models/debt.dart';
import 'package:grocery/shared/models/store.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class DebtsScreen extends ConsumerStatefulWidget {
  const DebtsScreen({super.key});

  @override
  ConsumerState<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends ConsumerState<DebtsScreen> {
  final _filterCtrl = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _filterCtrl.dispose();
    super.dispose();
  }

  String get _storeId => ref.read(authStateProvider).valueOrNull?.storeId ?? '';

  bool get _isManager {
    final user = ref.read(authStateProvider).valueOrNull;
    return user?.isManager == true || user?.isSuperAdmin == true;
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CreateDebtSheet(storeId: _isManager ? null : _storeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final debtsAsync = ref.watch(debtsListProvider(storeId: _storeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Долговая книга'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateSheet,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _filterCtrl,
              onChanged: (v) => setState(() => _filter = v.toLowerCase()),
              decoration: const InputDecoration(
                hintText: 'Поиск по имени',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: debtsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(debtsListProvider(storeId: _storeId)),
              ),
              data: (debts) {
                final filtered = debts
                    .where((d) => d.debtorName.toLowerCase().contains(_filter))
                    .toList()
                  ..sort((a, b) {
                    if (a.isPaid && !b.isPaid) return 1;
                    if (!a.isPaid && b.isPaid) return -1;
                    return b.amount.compareTo(a.amount);
                  });

                if (filtered.isEmpty) {
                  return const Center(child: Text('Нет долгов'));
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(debtsListProvider(storeId: _storeId)),
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _DebtTile(debt: filtered[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtTile extends StatelessWidget {
  final DebtRecord debt;

  const _DebtTile({required this.debt});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(debt.debtorName),
      subtitle: debt.debtorPhone != null ? Text(debt.debtorPhone!) : null,
      trailing: Text(
        formatSum(debt.amount),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: debt.isPaid ? Colors.grey : Colors.red,
        ),
      ),
      onTap: () => context.push('/debts/${debt.id}'),
    );
  }
}

class _CreateDebtSheet extends ConsumerStatefulWidget {
  // null means manager flow — user picks a store
  final String? storeId;

  const _CreateDebtSheet({required this.storeId});

  @override
  ConsumerState<_CreateDebtSheet> createState() => _CreateDebtSheetState();
}

class _CreateDebtSheetState extends ConsumerState<_CreateDebtSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  Store? _selectedStore;
  bool _isLoading = false;

  bool get _needsStorePicker => widget.storeId == null;

  String? get _effectiveStoreId =>
      _needsStorePicker ? _selectedStore?.id : widget.storeId;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim());
    final storeId = _effectiveStoreId;
    if (name.isEmpty || amount == null || amount <= 0) return;
    if (storeId == null || storeId.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(debtsListProvider(storeId: storeId).notifier).createDebt(
            storeId: storeId,
            debtorName: name,
            debtorPhone:
                _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
            amount: amount,
            description:
                _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          );
      if (mounted) Navigator.pop(context);
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
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Новый долг',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_needsStorePicker) ...[
            _StorePicker(
              selected: _selectedStore,
              onChanged: (store) => setState(() => _selectedStore = store),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Имя должника *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Телефон'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: const InputDecoration(labelText: 'Сумма долга *', suffixText: 'тг'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCtrl,
            decoration: const InputDecoration(labelText: 'Описание'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _create,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Создать'),
          ),
        ],
      ),
    );
  }
}

class _StorePicker extends ConsumerWidget {
  final Store? selected;
  final ValueChanged<Store?> onChanged;

  const _StorePicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storesListProvider);

    return storesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text(mapException(e), style: const TextStyle(color: Colors.red)),
      data: (stores) => InputDecorator(
        decoration: const InputDecoration(labelText: 'Магазин *'),
        child: DropdownButton<Store>(
          value: selected,
          hint: const Text('Выберите магазин'),
          isExpanded: true,
          underline: const SizedBox.shrink(),
          items: stores
              .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
