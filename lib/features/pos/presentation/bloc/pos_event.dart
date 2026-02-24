import 'package:equatable/equatable.dart';
import '../../../inventory/domain/entities/item.dart' as domain_item;
import '../../../partners/domain/entities/customer.dart';
import '../../domain/entities/payment_detail.dart';
import '../../../vouchers/domain/entities/voucher.dart';
abstract class PosEvent extends Equatable {
  const PosEvent();
  @override
  List<Object?> get props => [];
}

class LoadProducts extends PosEvent {}

class SearchProducts extends PosEvent {
  final String query;
  const SearchProducts(this.query);
  @override
  List<Object?> get props => [query];
}

class SelectCategory extends PosEvent {
  final int? categoryId;
  const SelectCategory(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class AddToCart extends PosEvent {
  final domain_item.Item item;
  final List<String> serialNumbers;
  const AddToCart(this.item, {this.serialNumbers = const []});
  @override
  List<Object?> get props => [item, serialNumbers];
}

class RemoveFromCart extends PosEvent {
  final domain_item.Item item;
  const RemoveFromCart(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateQuantity extends PosEvent {
  final domain_item.Item item;
  final int quantity;
  const UpdateQuantity(this.item, this.quantity);
  @override
  List<Object?> get props => [item, quantity];
}

class ProcessPayment extends PosEvent {
  final int paymentAmount;
  final String paymentMethod;
  final List<PaymentDetail>? splitPayments; // NEW: For split payment
  final int? shiftId;
  final int? userId;
  const ProcessPayment({
    required this.paymentAmount,
    required this.paymentMethod,
    this.splitPayments, // NEW
    this.shiftId,
    this.userId,
  });
  @override
  List<Object?> get props => [paymentAmount, paymentMethod, splitPayments, shiftId, userId];
}

class SetDiscount extends PosEvent {
  final int value;
  final String type; // 'fixed', 'percentage', 'promo'
  final int? promoId;
  final int minPurchase;
  final int maxDiscount;

  const SetDiscount(this.value, {this.type = 'fixed', this.promoId, this.minPurchase = 0, this.maxDiscount = 0});

  @override
  List<Object?> get props => [value, type, promoId, minPurchase, maxDiscount];
}


class HoldOrder extends PosEvent {
  final int? shiftId;
  final int? userId;
  
  const HoldOrder({this.shiftId, this.userId});
  
  @override
  List<Object?> get props => [shiftId, userId];
}

class LoadPendingOrders extends PosEvent {}

class ResumeOrder extends PosEvent {
  final int transactionId;
  const ResumeOrder(this.transactionId);
  @override
  List<Object?> get props => [transactionId];
}

class DeletePendingOrder extends PosEvent {
  final int transactionId;
  const DeletePendingOrder(this.transactionId);
  @override
  List<Object?> get props => [transactionId];
}

class LoadCustomers extends PosEvent {}

class SelectCustomer extends PosEvent {
  final Customer? customer;
  const SelectCustomer(this.customer);
  @override
  List<Object?> get props => [customer];
}

class SetTableInfo extends PosEvent {
  final String? tableNumber;
  final int? pax;
  const SetTableInfo({this.tableNumber, this.pax});
  @override
  List<Object?> get props => [tableNumber, pax];
}

class SetGuestName extends PosEvent {
  final String? guestName;
  const SetGuestName(this.guestName);
  @override
  List<Object?> get props => [guestName];
}

class SetDebt extends PosEvent {
  final bool isDebt;
  const SetDebt(this.isDebt);
  @override
  List<Object?> get props => [isDebt];
}

// Voucher Management Events
class LoadActiveVouchers extends PosEvent {}

class SelectVoucher extends PosEvent {
  final Voucher? voucher;
  const SelectVoucher(this.voucher);
  @override
  List<Object?> get props => [voucher];
}

class ClearVoucher extends PosEvent {}

class SetTransactionNote extends PosEvent {
  final String note;
  const SetTransactionNote(this.note);
  @override
  List<Object?> get props => [note];
}


class ClearCart extends PosEvent {}
