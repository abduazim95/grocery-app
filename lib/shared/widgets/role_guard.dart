import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/shared/models/user.dart';
import 'package:grocery/core/providers/core_providers.dart';

class RoleGuard extends ConsumerWidget {
  final List<UserRole> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null || !allowedRoles.contains(user.role)) {
      return fallback ?? const SizedBox.shrink();
    }
    return child;
  }
}
