import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grocery/shared/utils/error_messages.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  int _step = 1;
  bool _isLoading = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _passCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 0) {
        t.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .sendOtp(phone: _phoneCtrl.text.trim(), purpose: 'reset_password');
      setState(() => _step = 2);
      _startCountdown();
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

  Future<void> _reset() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            phone: _phoneCtrl.text.trim(),
            otp: _otpCtrl.text.trim(),
            newPassword: _passCtrl.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароль успешно изменён')),
        );
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
      appBar: AppBar(title: const Text('Сброс пароля')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_step == 1) ...[
              const Text('Введите номер телефона для сброса пароля'),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Телефон',
                  hintText: '+998901234567',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: const Text('Получить код'),
              ),
            ] else ...[
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: 'OTP-код'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Новый пароль'),
              ),
              const SizedBox(height: 16),
              if (_countdown > 0)
                Text('Повторить через $_countdown сек', textAlign: TextAlign.center)
              else
                TextButton(onPressed: _sendOtp, child: const Text('Отправить повторно')),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isLoading ? null : _reset,
                child: const Text('Изменить пароль'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
