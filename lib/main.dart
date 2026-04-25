import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/db/app_database.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_router.dart';
import 'package:grocery/core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  runApp(const ProviderScope(child: GroceryApp()));
}

class GroceryApp extends ConsumerWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Evict stale cache on app start
    ref.read(appDatabaseProvider).evictStale();

    return MaterialApp.router(
      title: 'Grocery',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
