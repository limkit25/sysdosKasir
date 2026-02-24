import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../pos/domain/repositories/transaction_repository.dart';
import '../../../pos/domain/entities/transaction_entity.dart';
import 'debt_event.dart';
import 'debt_state.dart';

@injectable
class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final TransactionRepository repository;

  DebtBloc(this.repository) : super(DebtLoading()) {
    on<LoadDebts>(_onLoadDebts);
    on<PayDebt>(_onPayDebt);
  }

  Future<void> _onLoadDebts(LoadDebts event, Emitter<DebtState> emit) async {
    emit(DebtLoading());
    final result = await repository.getDebtTransactions();
    result.fold(
      (failure) => emit(DebtError(failure.message)),
      (allDebts) {
        // Filter Logic
        List<Transaction> filtered = allDebts;

        // 1. Paid / Unpaid Status
        filtered = filtered.where((t) {
          final isFullyPaid = t.paymentAmount >= t.totalAmount;
          if (event.showUnpaid && event.showPaid) return true; // Show both
          if (event.showUnpaid && !isFullyPaid) return true;
          if (event.showPaid && isFullyPaid) return true;
          return false;
        }).toList();

        // 2. Search Name (Customer or Guest)
        if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
          final query = event.searchQuery!.toLowerCase();
          filtered = filtered.where((t) {
            final name = t.guestName?.toLowerCase() ?? '';
            return name.contains(query) || (t.customerId?.toString().contains(query) ?? false);
          }).toList();
        }

        // 3. Date Filter (Same Day)
        if (event.filterDate != null) {
          filtered = filtered.where((t) {
            return t.dateTime.year == event.filterDate!.year &&
                   t.dateTime.month == event.filterDate!.month &&
                   t.dateTime.day == event.filterDate!.day;
          }).toList();
        }

        // Sort dynamically (newest transaction first)
        filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        emit(DebtLoaded(
          filtered,
          searchQuery: event.searchQuery,
          filterDate: event.filterDate,
          showUnpaid: event.showUnpaid,
          showPaid: event.showPaid,
        ));
      },
    );
  }

  Future<void> _onPayDebt(PayDebt event, Emitter<DebtState> emit) async {
    // Keep showing loading or previous list with loading indicator?
    // For simplicity, emit Loading.
    emit(DebtLoading());
    
    final result = await repository.payDebt(event.transactionId, event.paymentAmount);
    
    result.fold(
      (failure) => emit(DebtError(failure.message)),
      (_) {
         // Reload after successful payment but keep last filters
         final currentState = state;
         if (currentState is DebtLoaded) {
            add(LoadDebts(
              searchQuery: currentState.searchQuery,
              filterDate: currentState.filterDate,
              showUnpaid: currentState.showUnpaid,
              showPaid: currentState.showPaid,
            ));
         } else {
            add(const LoadDebts());
         }
      },
    );
  }
}
