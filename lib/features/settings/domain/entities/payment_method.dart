import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final int id;
  final String name;
  final bool isActive;
  final bool isFixPayment;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.isActive,
    this.isFixPayment = false,
  });

  @override
  List<Object?> get props => [id, name, isActive, isFixPayment];
}
