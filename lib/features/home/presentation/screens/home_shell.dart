import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/shared/models/user.dart';

class HomeShell extends ConsumerWidget {
  final String location;
  final Widget child;

  const HomeShell({super.key, required this.location, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final tabs = _tabsFor(user);
    final currentIndex = _indexFor(location, tabs);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < 0 ? 0 : currentIndex,
        onDestinationSelected: (i) => context.go(tabs[i].route),
        destinations: tabs
            .map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label))
            .toList(),
      ),
    );
  }

  static List<_Tab> _tabsFor(User? user) => [
        _Tab(AppRoutes.products, Icons.inventory_2_outlined, 'Товары'),
        _Tab(AppRoutes.sales, Icons.point_of_sale_outlined, 'Продажи'),
        _Tab(AppRoutes.debts, Icons.account_balance_wallet_outlined, 'Долги'),
        _Tab(AppRoutes.purchases, Icons.local_shipping_outlined, 'Закуп'),
        if (user != null)
          _Tab(AppRoutes.more, Icons.more_horiz, 'Ещё'),
      ];

  int _indexFor(String loc, List<_Tab> tabs) {
    for (var i = 0; i < tabs.length; i++) {
      if (loc.startsWith(tabs[i].route)) return i;
    }
    return 0;
  }
}

class _Tab {
  final String route;
  final IconData icon;
  final String label;

  const _Tab(this.route, this.icon, this.label);
}
