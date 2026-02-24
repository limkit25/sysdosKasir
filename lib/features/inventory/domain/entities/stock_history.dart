import 'package:equatable/equatable.dart';
import 'stock_change_type_enum.dart';

class StockHistory extends Equatable {
  final int? id;
  final int itemId;
  final int oldStock;
  final int newStock;
  final int changeAmount; // Positive for add, negative for deduct
  final StockChangeType type;
  final DateTime date;
  final String? note;
  final String? serials;

  const StockHistory({
    this.id,
    required this.itemId,
    required this.oldStock,
    required this.newStock,
    required this.changeAmount,
    required this.type,
    required this.date,
    this.note,
    this.serials,
  });

  @override
  List<Object?> get props => [id, itemId, oldStock, newStock, changeAmount, type, date, note, serials];
}
