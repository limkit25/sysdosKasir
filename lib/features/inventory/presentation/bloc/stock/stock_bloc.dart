import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/inventory_repository.dart';
import 'stock_event.dart';
import 'stock_state.dart';

@injectable
class StockBloc extends Bloc<StockEvent, StockState> {
  final InventoryRepository repository;

  StockBloc(this.repository) : super(StockInitial()) {
    on<LoadStockHistory>(_onLoadStockHistory);
    on<AdjustStock>(_onAdjustStock);
  }

  Future<void> _onLoadStockHistory(LoadStockHistory event, Emitter<StockState> emit) async {
    emit(StockLoading());
    final result = await repository.getStockHistory(event.itemId, startDate: event.startDate, endDate: event.endDate);
    result.fold(
      (failure) => emit(StockError(failure.message)),
      (history) => emit(StockHistoryLoaded(history)),
    );
  }

  Future<void> _onAdjustStock(AdjustStock event, Emitter<StockState> emit) async {
    emit(StockLoading());
    final result = await repository.adjustStock(
      itemId: event.itemId,
      newStock: event.newStock,
      note: event.note,
      type: event.type,
      serials: event.serials,
    );
    result.fold(
      (failure) => emit(StockError(failure.message)),
      (_) {
        emit(const StockOperationSuccess('Stock adjusted successfully'));
        add(LoadStockHistory(event.itemId));
      },
    );
  }
}
