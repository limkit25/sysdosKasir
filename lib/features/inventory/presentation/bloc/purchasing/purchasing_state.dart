import 'package:equatable/equatable.dart';
import '../../../domain/entities/purchase.dart';
import '../../../domain/entities/purchase_item.dart';

abstract class PurchasingState extends Equatable {
  const PurchasingState();
  
  @override
  List<Object?> get props => [];
}

class PurchasingInitial extends PurchasingState {}

class PurchasingLoading extends PurchasingState {}

class PurchasingLoaded extends PurchasingState {
  final List<Purchase> purchases;

  const PurchasingLoaded(this.purchases);
  
  @override
  List<Object?> get props => [purchases];
}

class PurchasingSuccess extends PurchasingState {
  final int purchaseId;

  const PurchasingSuccess(this.purchaseId);

  @override
  List<Object?> get props => [purchaseId];
}

class PurchasingFailure extends PurchasingState {
  final String message;

  const PurchasingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PurchaseItemsLoaded extends PurchasingState {
  final List<PurchaseItem> items;

  const PurchaseItemsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}
