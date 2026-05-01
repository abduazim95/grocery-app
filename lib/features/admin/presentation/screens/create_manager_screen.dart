import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:grocery/features/admin/presentation/providers/admin_provider.dart';
import 'package:grocery/shared/models/business.dart';
import 'package:grocery/shared/utils/error_messages.dart';

class CreateManagerScreen extends ConsumerStatefulWidget {
  // Если передан — dropdown скрыт, бизнес уже выбран
  final String? preselectedBusinessId;

  const CreateManagerScreen({super.key, this.preselectedBusinessId});

  @override
  ConsumerState<CreateManagerScreen> createState() => _CreateManagerScreenState();
}

class _CreateManagerScreenState extends ConsumerState<CreateManagerScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;
  String? _selectedBusinessId;

  @override
  void initState() {
    super.initState();
    _selectedBusinessId = widget.preselectedBusinessId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_nameCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty ||
        _selectedBusinessId == null) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(adminRepositoryProvider).createManager(
            businessId: _selectedBusinessId!,
            name: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            password: _passCtrl.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Руководитель создан')));
        context.pop();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Новый руководитель')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.preselectedBusinessId == null) _BusinessDropdown(
              selectedId: _selectedBusinessId,
              onChanged: (id) => setState(() => _selectedBusinessId = id),
            ),
            if (widget.preselectedBusinessId == null) const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Имя *'),
              textCapitalization: TextCapitalization.words,
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
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Пароль *',
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _create,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessDropdown extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _BusinessDropdown({required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(businessesProvider);

    return state.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Ошибка загрузки бизнесов: ${mapException(e)}',
          style: TextStyle(color: Theme.of(context).colorScheme.error)),
      data: (businesses) => DropdownButtonFormField<String>(
        value: selectedId,
        decoration: const InputDecoration(labelText: 'Бизнес *'),
        items: businesses
            .map((b) => DropdownMenuItem(value: b.id, child: Text(b.name)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
