import 'package:equatable/equatable.dart';
import 'transaction_item.dart';
import 'payment_detail.dart';

class Transaction extends Equatable {
  final int? id;
  final DateTime dateTime;
  final int totalAmount;
  final int paymentAmount;
  final int changeAmount;
  final String paymentMethod;
  final int discountAmount;
  final int taxAmount;
  final int serviceFeeAmount;
  final String status;
  final int? customerId;
  final String? tableNumber;
  final int? pax;
  final String? note;
  final bool isDebt;
  final String? guestName;
  final List<TransactionItem> items;
  final List<PaymentDetail>? splitPayments; // NEW: For split payment support
  final int? shiftId;
  final int? userId;

  const Transaction({
    this.id,
    required this.dateTime,
    required this.totalAmount,
    required this.paymentAmount,
    required this.changeAmount,
    this.paymentMethod = 'CASH',
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.serviceFeeAmount = 0,
    this.status = 'success',
    this.customerId,
    this.tableNumber,
    this.pax,
    this.note,
    this.isDebt = false,
    this.guestName,
    required this.items,
    this.splitPayments, // NEW
    this.shiftId,
    this.userId,
  });

  @override
  List<Object?> get props => [
        id,
        dateTime,
        totalAmount,
        paymentAmount,
        changeAmount,
        paymentMethod,
        discountAmount,
        taxAmount,
        serviceFeeAmount,
        status,
        customerId,
        tableNumber,
        pax,
        note,
        isDebt,
        guestName,
        items,
        splitPayments, // NEW
        shiftId,
        userId,
      ];
}
