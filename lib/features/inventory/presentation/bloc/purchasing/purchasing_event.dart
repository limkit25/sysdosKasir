import 'package:equatable/equatable.dart';
import '../../../domain/entities/purchase.dart';
import '../../../domain/entities/purchase_item.dart';

abstract class PurchasingEvent extends Equatable {
  const PurchasingEvent();

  @override
  List<Object?> get props => [];
}

class LoadPurchases extends PurchasingEvent {}

class SubmitPurchase extends PurchasingEvent {
  final Purchase purchase;
  final List<PurchaseItem> items;

  const SubmitPurchase({required this.purchase, required this.items});

  @override
  List<Object?> get props => [purchase, items];
}

class LoadPurchaseItems extends PurchasingEvent {
  final int purchaseId;

  const LoadPurchaseItems(this.purchaseId);

  @override
  List<Object?> get props => [purchaseId];
}
