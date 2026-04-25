import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/admin/presentation/screens/create_manager_screen.dart';
import 'package:grocery/features/auth/presentation/screens/login_screen.dart';
import 'package:grocery/features/auth/presentation/screens/register_screen.dart';
import 'package:grocery/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:grocery/features/debts/presentation/screens/debt_detail_screen.dart';
import 'package:grocery/features/debts/presentation/screens/debts_screen.dart';
import 'package:grocery/features/home/presentation/screens/home_shell.dart';
import 'package:grocery/features/home/presentation/screens/more_screen.dart';
import 'package:grocery/features/products/presentation/screens/create_product_screen.dart';
import 'package:grocery/features/products/presentation/screens/edit_product_screen.dart';
import 'package:grocery/features/products/presentation/screens/products_screen.dart';
import 'package:grocery/features/profile/presentation/screens/profile_screen.dart';
import 'package:grocery/features/purchases/presentation/screens/purchase_detail_screen.dart';
import 'package:grocery/features/purchases/presentation/screens/purchases_screen.dart';
import 'package:grocery/features/sales/presentation/screens/create_sale_screen.dart';
import 'package:grocery/features/sales/presentation/screens/sales_screen.dart';
import 'package:grocery/features/server_setup/presentation/screens/server_setup_screen.dart';
import 'package:grocery/features/stock/presentation/screens/stock_screen.dart';
import 'package:grocery/features/stock/presentation/screens/transfer_stock_screen.dart';
import 'package:grocery/features/stores/presentation/screens/create_store_screen.dart';
import 'package:grocery/features/stores/presentation/screens/stores_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    initialLocation: AppRoutes.serverSetup,
    refreshListenable: notifier,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final host = ref.read(serverConfigProvider).valueOrNull;
      final user = ref.read(authStateProvider).valueOrNull;
      final isSetup = loc == AppRoutes.serverSetup;
      final isAuth = loc.startsWith('/auth');

      if (host == null && !isSetup) return AppRoutes.serverSetup;
      if (host != null && isSetup) return AppRoutes.login;

      if (user == null && !isAuth) return AppRoutes.login;
      if (user != null && isAuth) return AppRoutes.products;

      if (loc.startsWith('/admin') && !(user?.isSuperAdmin ?? false)) {
        return AppRoutes.products;
      }
      if ((loc.startsWith('/stores') || loc.startsWith('/stock')) &&
          !(user?.isManager ?? false)) {
        return AppRoutes.products;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.serverSetup,
        builder: (_, __) => const ServerSetupScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, __) => const ResetPasswordScreen(),
      ),
      ShellRoute(
        builder: (_, state, child) =>
            HomeShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.products,
            builder: (_, __) => const ProductsScreen(),
          ),
          GoRoute(
            path: AppRoutes.sales,
            builder: (_, __) => const SalesScreen(),
          ),
          GoRoute(
            path: AppRoutes.debts,
            builder: (_, __) => const DebtsScreen(),
          ),
          GoRoute(
            path: AppRoutes.purchases,
            builder: (_, __) => const PurchasesScreen(),
          ),
          GoRoute(
            path: AppRoutes.more,
            builder: (_, __) => const MoreScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.newProduct,
        builder: (_, state) => CreateProductScreen(
          initialBarcode: (state.extra as Map<String, dynamic>?)?['barcode'] as String?,
        ),
      ),
      GoRoute(
        path: AppRoutes.editProduct,
        builder: (_, s) => EditProductScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.newSale, builder: (_, __) => const CreateSaleScreen()),
      GoRoute(
        path: AppRoutes.purchaseDetail,
        builder: (_, s) => PurchaseDetailScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.debtDetail,
        builder: (_, s) => DebtDetailScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.stores, builder: (_, __) => const StoresScreen()),
      GoRoute(path: AppRoutes.createStore, builder: (_, __) => const CreateStoreScreen()),
      GoRoute(
        path: AppRoutes.storeStock,
        builder: (_, s) => StockScreen(storeId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.stockTransfer,
        builder: (_, __) => const TransferStockScreen(),
      ),
      GoRoute(
        path: AppRoutes.newManager,
        builder: (_, __) => const CreateManagerScreen(),
      ),
      GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
    ],
  );
}

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(serverConfigProvider, (_, __) => notifyListeners());
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}
