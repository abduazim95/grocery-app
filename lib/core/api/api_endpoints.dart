abstract class Endpoints {
  // Auth
  static const sendOtp = '/v1/auth/send-otp';
  static const register = '/v1/auth/register';
  static const login = '/v1/auth/login';
  static const resetPassword = '/v1/auth/reset-password';
  // Products
  static const products = '/v1/products';
  static String productById(String id) => '/v1/products/$id';
  static String productBarcode(String b) => '/v1/products/barcode/$b';
  // Sales
  static const sales = '/v1/sales';
  static String saleById(String id) => '/v1/sales/$id';
  // Purchases
  static const purchases = '/v1/purchases';
  static String purchaseById(String id) => '/v1/purchases/$id';
  static String purchaseItems(String id) => '/v1/purchases/$id/items';
  static String purchaseItem(String id, String itemId) => '/v1/purchases/$id/items/$itemId';
  static String purchaseItemBought(String id, String itemId) =>
      '/v1/purchases/$id/items/$itemId/bought';
  static String purchaseClose(String id) => '/v1/purchases/$id/close';
  // Debts
  static const debts = '/v1/debts';
  static String debtById(String id) => '/v1/debts/$id';
  static String debtPayments(String id) => '/v1/debts/$id/payments';
  static String debtPayment(String id, String paymentId) => '/v1/debts/$id/payments/$paymentId';
  // Stores
  static const stores = '/v1/stores';
  static String storeById(String id) => '/v1/stores/$id';
  static String storeSellers(String id) => '/v1/stores/$id/sellers';
  static String storeStock(String id) => '/v1/stores/$id/stock';
  // Stock
  static const stockTransfer = '/v1/stock/transfer';
  // Admin
  static const managers = '/v1/admin/managers';
  static String userById(String id) => '/v1/admin/users/$id';
}
