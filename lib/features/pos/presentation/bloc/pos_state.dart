import 'package:equatable/equatable.dart';
import '../../../inventory/domain/entities/item.dart' as domain_item;
import '../../../inventory/domain/entities/category.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../partners/domain/entities/customer.dart';
import '../../../settings/domain/entities/payment_method.dart';
import '../../../vouchers/domain/entities/voucher.dart';

abstract class PosState extends Equatable {
  const PosState();
  @override
  List<Object?> get props => [];
}

class PosInitial extends PosState {}

class PosLoading extends PosState {}

class PosLoaded extends PosState {
  final List<domain_item.Item> products; // All products available to sell
  final List<domain_item.Item> filteredProducts;
  final List<CartItem> cart;
  final String searchQuery;
  final List<Category> categories;
  final int? selectedCategoryId;
  final int discountAmount;
  final String discountType; // 'fixed', 'percentage', 'promo'
  final int? selectedPromoId;
  final int discountValue; // The raw value (money or %)

  final int minPurchase;
  final int maxDiscount;
  final double taxRate;
  final double serviceFeeRate;
  
  final List<Transaction> pendingTransactions;
  final int? originalPendingTransactionId;
  
  // Advanced Payment Features
  final List<Customer> customers; // List of available customers
  final Customer? selectedCustomer;
  final String? tableNumber;
  final int? pax; // Number of people
  final String? note;
  final bool isDebt;
  final String? guestName;
  final List<PaymentMethod> paymentMethods;
  
  // Voucher Management
  final List<Voucher> activeVouchers;
  final Voucher? selectedVoucher;
  final int voucherAmount;

  const PosLoaded({
    this.products = const [],
    this.filteredProducts = const [],
    this.cart = const [],
    this.searchQuery = '',
    this.categories = const [],
    this.selectedCategoryId,
    this.discountAmount = 0, // Calculated amount in Rp
    this.discountType = 'fixed',
    this.selectedPromoId,
    this.discountValue = 0,
    this.minPurchase = 0,
    this.maxDiscount = 0,
    this.taxRate = 0.0,
    this.serviceFeeRate = 0.0,
    this.pendingTransactions = const [],
    this.originalPendingTransactionId,
    this.customers = const [],
    this.selectedCustomer,
    this.tableNumber,
    this.pax,
    this.note,
    this.isDebt = false,
    this.guestName,
    this.paymentMethods = const [], // Default empty
    this.activeVouchers = const [],
    this.selectedVoucher,
    this.voucherAmount = 0,
  });

  int get subtotal => cart.fold(0, (sum, item) => sum + item.subtotal);
  
  int get serviceFeeAmount {
    final base = subtotal - discountAmount;
    if (base <= 0) return 0;
    return (base * serviceFeeRate / 100).round();
  }

  int get taxAmount {
    final base = subtotal - discountAmount;
    final taxable = base + serviceFeeAmount;
    if (taxable <= 0) return 0;
    return (taxable * taxRate / 100).round();
  }

  int get grandTotal => (subtotal - discountAmount) + serviceFeeAmount + taxAmount;
  
  // Final total after voucher deduction (Opsi B: voucher after tax & service)
  int get finalTotal => grandTotal - voucherAmount;

  PosLoaded copyWith({
    List<domain_item.Item>? products,
    List<domain_item.Item>? filteredProducts,
    List<CartItem>? cart,
    String? searchQuery,
    List<Category>? categories,
    int? selectedCategoryId,
    int? discountAmount,
    String? discountType,
    int? selectedPromoId,
    int? discountValue,
    int? minPurchase,
    int? maxDiscount,
    bool clearPromo = false,
    double? taxRate,
    double? serviceFeeRate,
    List<Transaction>? pendingTransactions,
    int? originalPendingTransactionId,
    bool clearOriginalPendingId = false,
    List<Customer>? customers,
    Customer? selectedCustomer,
    bool clearSelectedCustomer = false,
    String? tableNumber,
    int? pax,
    String? note,
    bool? isDebt,
    String? guestName,
    List<PaymentMethod>? paymentMethods,
    List<Voucher>? activeVouchers,
    Voucher? selectedVoucher,
    int? voucherAmount,
    bool clearVoucher = false,
  }) {
    return PosLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      cart: cart ?? this.cart,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      discountAmount: discountAmount ?? this.discountAmount,
      discountType: discountType ?? this.discountType,
      selectedPromoId: clearPromo ? null : (selectedPromoId ?? this.selectedPromoId),
      discountValue: discountValue ?? this.discountValue,
      minPurchase: minPurchase ?? this.minPurchase,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      taxRate: taxRate ?? this.taxRate,
      serviceFeeRate: serviceFeeRate ?? this.serviceFeeRate,
      pendingTransactions: pendingTransactions ?? this.pendingTransactions,
      originalPendingTransactionId: clearOriginalPendingId ? null : (originalPendingTransactionId ?? this.originalPendingTransactionId),
      customers: customers ?? this.customers,
      selectedCustomer: clearSelectedCustomer ? null : (selectedCustomer ?? this.selectedCustomer),
      tableNumber: tableNumber ?? this.tableNumber,
      pax: pax ?? this.pax,
      note: note ?? this.note,
      isDebt: isDebt ?? this.isDebt,
      guestName: guestName ?? this.guestName,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      activeVouchers: activeVouchers ?? this.activeVouchers,
      selectedVoucher: clearVoucher ? null : (selectedVoucher ?? this.selectedVoucher),
      voucherAmount: clearVoucher ? 0 : (voucherAmount ?? this.voucherAmount),
    );
  }

  @override
  List<Object?> get props => [
    products, filteredProducts, cart, searchQuery, categories, selectedCategoryId, 
    discountAmount, discountType, (selectedPromoId ?? -1), discountValue, 
    minPurchase, maxDiscount, taxRate, serviceFeeRate, pendingTransactions, 
    originalPendingTransactionId, customers, selectedCustomer, tableNumber, pax, note, isDebt, guestName, paymentMethods,
    activeVouchers, selectedVoucher, voucherAmount
  ];
}

class PosSuccess extends PosState {
  final int transactionId;
  final int changeAmount;
  const PosSuccess({required this.transactionId, required this.changeAmount});
  @override
  List<Object?> get props => [transactionId, changeAmount];
}

class PosError extends PosState {
  final String message;
  const PosError(this.message);
  @override
  List<Object?> get props => [message];
}
