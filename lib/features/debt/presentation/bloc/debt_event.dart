import 'package:equatable/equatable.dart';

abstract class DebtEvent extends Equatable {
  const DebtEvent();

  @override
  List<Object?> get props => [];
}

class LoadDebts extends DebtEvent {
  final String? searchQuery;
  final DateTime? filterDate;
  final bool showUnpaid;
  final bool showPaid;

  const LoadDebts({
    this.searchQuery,
    this.filterDate,
    this.showUnpaid = true,
    this.showPaid = false,
  });

  @override
  List<Object?> get props => [searchQuery, filterDate, showUnpaid, showPaid];
}

class PayDebt extends DebtEvent {
  final int transactionId;
  final int paymentAmount;

  const PayDebt(this.transactionId, this.paymentAmount);

  @override
  List<Object?> get props => [transactionId, paymentAmount];
}
