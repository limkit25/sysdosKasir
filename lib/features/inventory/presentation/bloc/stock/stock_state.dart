import 'package:equatable/equatable.dart';
import '../../../domain/entities/stock_history.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockHistoryLoaded extends StockState {
  final List<StockHistory> history;

  const StockHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class StockOperationSuccess extends StockState {
  final String message;

  const StockOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object?> get props => [message];
}
