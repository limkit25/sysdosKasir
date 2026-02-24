import 'package:equatable/equatable.dart';


class Purchase extends Equatable {
  final int? id;
  final int supplierId;
  final DateTime date;
  final int totalAmount; // In Rupiah
  final String? invoiceNumber;
  final String? note;

  const Purchase({
    this.id,
    required this.supplierId,
    required this.date,
    required this.totalAmount,
    this.invoiceNumber,
    this.note,
  });

  @override
  List<Object?> get props => [id, supplierId, date, totalAmount, invoiceNumber, note];
}
