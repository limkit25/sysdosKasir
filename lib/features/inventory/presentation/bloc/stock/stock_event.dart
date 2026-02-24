import 'package:equatable/equatable.dart';
import '../../../domain/entities/stock_change_type_enum.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object?> get props => [];
}

class LoadStockHistory extends StockEvent {
  final int itemId;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadStockHistory(this.itemId, {this.startDate, this.endDate});

  @override
  List<Object?> get props => [itemId, startDate, endDate];
}

class AdjustStock extends StockEvent {
  final int itemId;
  final int newStock;
  final String note;
  final StockChangeType type;
  final List<String>? serials;

  const AdjustStock({
    required this.itemId,
    required this.newStock,
    required this.note,
    required this.type,
    this.serials,
  });

  @override
  List<Object?> get props => [itemId, newStock, note, type, serials];
}
