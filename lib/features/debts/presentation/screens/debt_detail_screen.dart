import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/debts/presentation/providers/debts_provider.dart';
import 'package:grocery/shared/models/debt.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/confirm_dialog.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class DebtDetailScreen extends ConsumerWidget {
  final String id;

  const DebtDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtAsync = ref.watch(debtDetailNotifierProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Долг'),
        actions: [
          debtAsync.whenOrNull(
            data: (debt) => PopupMenuButton<String>(
              onSelected: (action) async {
                if (action == 'edit') {
                  _showEditSheet(context, ref, debt);
                } else if (action == 'delete') {
                  final ok = await showConfirmDialog(
                    context,
                    title: 'Удалить долг?',
                    content:
                        'Запись о долге "${debt.debtorName}" будет удалена.',
                  );
                  if (ok && context.mounted) {
                    try {
                      await ref
                          .read(debtDetailNotifierProvider(id).notifier)
                          .delete();
                      context.pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(mapException(e)),
                            backgroundColor: Colors.red),
                      );
                    }
                  }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                PopupMenuItem(value: 'delete', child: Text('Удалить')),
              ],
            ),
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: debtAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
        data: (debt) => _DebtBody(debt: debt, id: id),
      ),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, DebtRecord debt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditDebtSheet(debt: debt, id: id),
    );
  }
}

class _DebtBody extends ConsumerWidget {
  final DebtRecord debt;
  final String id;

  const _DebtBody({required this.debt, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isManager = ref.watch(authStateProvider).valueOrNull?.isManager ?? false;

    return Column(
      children: [
        ListTile(
          title: Text(debt.debtorName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (debt.debtorPhone != null) Text(debt.debtorPhone!),
              if (debt.description.isNotEmpty) Text('"${debt.description}"'),
            ],
          ),
        ),
        ListTile(
          title: const Text('Текущий долг'),
          trailing: Text(
            formatSum(debt.amount),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: debt.isPaid ? Colors.grey : Colors.red,
            ),
          ),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('История операций:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: debt.payments.length,
            itemBuilder: (_, i) {
              final p = debt.payments[debt.payments.length - 1 - i];
              return ListTile(
                leading: Icon(
                  p.amount > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: p.amount > 0 ? Colors.red : Colors.green,
                ),
                title: Text(
                  '${p.amount > 0 ? '+' : ''}${formatSum(p.amount.abs())}',
                  style: TextStyle(
                    color: p.amount > 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: p.note.isNotEmpty ? Text(p.note) : null,
                trailing: isManager
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(formatDate(p.createdAt),
                              style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () =>
                                _showEditPaymentSheet(context, ref, p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            onPressed: () =>
                                _confirmDeletePayment(context, ref, p),
                          ),
                        ],
                      )
                    : Text(formatDate(p.createdAt)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showPaymentSheet(context, ref, isAdd: true),
                  child: const Text('Добрать долг'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => _showPaymentSheet(context, ref, isAdd: false),
                  child: const Text('Внести оплату'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPaymentSheet(BuildContext context, WidgetRef ref, {required bool isAdd}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PaymentSheet(id: id, isAdd: isAdd),
    );
  }

  void _showEditPaymentSheet(BuildContext context, WidgetRef ref, DebtPayment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditPaymentSheet(debtId: id, payment: payment),
    );
  }

  Future<void> _confirmDeletePayment(
      BuildContext context, WidgetRef ref, DebtPayment payment) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Удалить операцию?',
      content:
          'Операция "${formatSum(payment.amount.abs())}" будет удалена. Баланс долга пересчитается автоматически.',
    );
    if (!confirmed) return;
    try {
      await ref
          .read(debtDetailNotifierProvider(id).notifier)
          .deletePayment(payment.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _PaymentSheet extends ConsumerStatefulWidget {
  final String id;
  final bool isAdd;

  const _PaymentSheet({required this.id, required this.isAdd});

  @override
  ConsumerState<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<_PaymentSheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) return;

    setState(() => _isLoading = true);
    try {
      final signedAmount = widget.isAdd ? amount : -amount;
      await ref
          .read(debtDetailNotifierProvider(widget.id).notifier)
          .addPayment(signedAmount, note: _noteCtrl.text.trim());
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
          Text(
            widget.isAdd ? 'Добрать долг' : 'Внести оплату',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: const InputDecoration(labelText: 'Сумма *', suffixText: 'тг'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            decoration: const InputDecoration(labelText: 'Комментарий'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: widget.isAdd
                ? FilledButton.styleFrom(backgroundColor: Colors.red)
                : null,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(widget.isAdd ? 'Добавить долг' : 'Записать оплату'),
          ),
        ],
      ),
    );
  }
}

class _EditPaymentSheet extends ConsumerStatefulWidget {
  final String debtId;
  final DebtPayment payment;

  const _EditPaymentSheet({required this.debtId, required this.payment});

  @override
  ConsumerState<_EditPaymentSheet> createState() => _EditPaymentSheetState();
}

class _EditPaymentSheetState extends ConsumerState<_EditPaymentSheet> {
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountCtrl =
        TextEditingController(text: widget.payment.amount.abs().toStringAsFixed(0));
    _noteCtrl = TextEditingController(text: widget.payment.note);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final abs = double.tryParse(_amountCtrl.text.trim());
    if (abs == null || abs <= 0) return;
    final signed = widget.payment.amount < 0 ? -abs : abs;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(debtDetailNotifierProvider(widget.debtId).notifier)
          .updatePayment(widget.payment.id, signed, note: _noteCtrl.text.trim());
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
      padding:
          EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Редактировать операцию',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _amountCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: const InputDecoration(labelText: 'Сумма *', suffixText: 'тг'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            decoration: const InputDecoration(labelText: 'Комментарий'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class _EditDebtSheet extends ConsumerStatefulWidget {
  final DebtRecord debt;
  final String id;

  const _EditDebtSheet({required this.debt, required this.id});

  @override
  ConsumerState<_EditDebtSheet> createState() => _EditDebtSheetState();
}

class _EditDebtSheetState extends ConsumerState<_EditDebtSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _descCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.debt.debtorName);
    _phoneCtrl = TextEditingController(text: widget.debt.debtorPhone ?? '');
    _descCtrl = TextEditingController(text: widget.debt.description);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(debtDetailNotifierProvider(widget.id).notifier).editDebt(
            debtorName: _nameCtrl.text.trim(),
            debtorPhone:
                _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
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
          const Text('Редактировать',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
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
            controller: _descCtrl,
            decoration: const InputDecoration(labelText: 'Описание'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
