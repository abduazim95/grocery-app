import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/server_setup/presentation/providers/server_setup_provider.dart';

class ServerSetupScreen extends ConsumerStatefulWidget {
  const ServerSetupScreen({super.key});

  @override
  ConsumerState<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends ConsumerState<ServerSetupScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serverSetupNotifierProvider);
    final notifier = ref.read(serverSetupNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Icon(
                Icons.store,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Grocery',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              const Text(
                'Введите адрес сервера',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ctrl,
                keyboardType: TextInputType.url,
                onChanged: notifier.setUrl,
                decoration: InputDecoration(
                  hintText: '192.168.1.100:8080',
                  errorText: state.errorMessage,
                  suffixIcon: state.isVerified
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Примеры:\n• 192.168.1.100:8080\n• https://grocery.company.com',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed:
                    state.url.isEmpty || state.isTesting ? null : notifier.testConnection,
                child: state.isTesting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Проверка...'),
                        ],
                      )
                    : const Text('Проверить соединение'),
              ),
              if (state.isVerified) ...[
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Сервер доступен', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: state.isVerified ? notifier.save : null,
                child: const Text('Продолжить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
