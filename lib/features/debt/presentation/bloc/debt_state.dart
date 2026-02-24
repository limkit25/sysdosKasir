import 'package:equatable/equatable.dart';
import '../../../pos/domain/entities/transaction_entity.dart';

abstract class DebtState extends Equatable {
  const DebtState();
  
  @override
  List<Object?> get props => [];
}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final List<Transaction> debts;
  final String? successMessage;
  
  // Filters
  final String? searchQuery;
  final DateTime? filterDate;
  final bool showUnpaid;
  final bool showPaid;

  const DebtLoaded(
    this.debts, {
    this.successMessage,
    this.searchQuery,
    this.filterDate,
    this.showUnpaid = true,
    this.showPaid = false,
  });

  @override
  List<Object?> get props => [debts, successMessage, searchQuery, filterDate, showUnpaid, showPaid];
}

class DebtError extends DebtState {
  final String message;

  const DebtError(this.message);

  @override
  List<Object?> get props => [message];
}
