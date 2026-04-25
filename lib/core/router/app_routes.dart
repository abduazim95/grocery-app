abstract class AppRoutes {
  static const serverSetup = '/server-setup';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const resetPassword = '/auth/reset-password';
  static const products = '/home/products';
  static const sales = '/home/sales';
  static const debts = '/home/debts';
  static const purchases = '/home/purchases';
  static const more = '/home/more';
  static const newProduct = '/products/new';
  static const editProduct = '/products/:id/edit';
  static const newSale = '/sales/new';
  static const purchaseDetail = '/purchases/:id';
  static const debtDetail = '/debts/:id';
  static const stores = '/stores';
  static const createStore = '/stores/new';
  static const storeStock = '/stores/:id/stock';
  static const stockTransfer = '/stock/transfer';
  static const newManager = '/admin/managers/new';
  static const profile = '/profile';
  static const settings = '/settings';
}
