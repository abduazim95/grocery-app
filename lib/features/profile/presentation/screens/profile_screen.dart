import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/confirm_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.name),
              subtitle: Text(user.phone),
              trailing: Text(
                user.roleLabel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Изменить имя'),
              onTap: () => _showChangeName(context, ref, user.name),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Изменить пароль'),
              onTap: () => _showChangePassword(context, ref),
            ),
            const Divider(),
          ],
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('Очистить кэш'),
            onTap: () => _clearCache(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Выйти', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context, ref),
          ),
        ],
      ),
    );
  }

  void _showChangeName(BuildContext context, WidgetRef ref, String currentName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ChangeNameSheet(currentName: currentName),
    );
  }

  void _showChangePassword(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Очистить кэш?',
      content:
          'Данные будут заново загружены с сервера. Это может замедлить первое открытие разделов.',
      confirmText: 'Очистить',
      isDestructive: false,
    );
    if (!ok) return;
    try {
      await ref.read(appDatabaseProvider).clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Кэш очищен')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Выйти?',
      content: 'Вы будете перенаправлены на страницу входа.',
      confirmText: 'Выйти',
    );
    if (!ok) return;
    await ref.read(authStateProvider.notifier).logout();
  }
}

class _ChangeNameSheet extends ConsumerStatefulWidget {
  final String currentName;

  const _ChangeNameSheet({required this.currentName});

  @override
  ConsumerState<_ChangeNameSheet> createState() => _ChangeNameSheetState();
}

class _ChangeNameSheetState extends ConsumerState<_ChangeNameSheet> {
  late final TextEditingController _ctrl;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _ctrl.text.trim();
    if (name.length < 2) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final updated = await ref.read(profileRepositoryProvider).updateName(name);
      await ref.read(authStateProvider.notifier).updateUser(updated);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Имя обновлено')),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = mapException(e));
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
          const Text('Изменить имя',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            autofocus: true,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            decoration: const InputDecoration(labelText: 'Имя'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordSheet extends ConsumerStatefulWidget {
  const _ChangePasswordSheet();

  @override
  ConsumerState<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<_ChangePasswordSheet> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  String? _confirmError;
  String? _serverError;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() {
        _confirmError = 'Пароли не совпадают';
        _serverError = null;
      });
      return;
    }
    setState(() {
      _confirmError = null;
      _serverError = null;
    });

    if (_oldCtrl.text.isEmpty || _newCtrl.text.length < 6) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(profileRepositoryProvider).changePassword(
            oldPassword: _oldCtrl.text,
            newPassword: _newCtrl.text,
            confirmPassword: _confirmCtrl.text,
          );
      if (mounted) {
        Navigator.pop(context);
        // Используем rootNavigator context, чтобы снекбар был поверх bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароль изменён')),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _serverError = mapException(e));
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
          const Text('Изменить пароль',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _oldCtrl,
            obscureText: true,
            onChanged: (_) {
              if (_serverError != null) setState(() => _serverError = null);
            },
            decoration: const InputDecoration(labelText: 'Текущий пароль'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Новый пароль',
              helperText: 'Минимум 6 символов',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmCtrl,
            obscureText: true,
            onChanged: (_) {
              if (_confirmError != null) setState(() => _confirmError = null);
            },
            decoration: InputDecoration(
              labelText: 'Подтверждение пароля',
              errorText: _confirmError,
            ),
          ),
          if (_serverError != null) ...[
            const SizedBox(height: 8),
            Text(
              _serverError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Изменить пароль'),
          ),
        ],
      ),
    );
  }
}
