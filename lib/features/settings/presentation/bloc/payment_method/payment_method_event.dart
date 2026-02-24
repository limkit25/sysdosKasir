import 'package:equatable/equatable.dart';

abstract class PaymentMethodEvent extends Equatable {
  const PaymentMethodEvent();
  @override
  List<Object?> get props => [];
}

class LoadPaymentMethods extends PaymentMethodEvent {}

class AddPaymentMethod extends PaymentMethodEvent {
  final String name;
  const AddPaymentMethod(this.name);
  @override
  List<Object?> get props => [name];
}

class DeletePaymentMethod extends PaymentMethodEvent {
  final int id;
  const DeletePaymentMethod(this.id);
  @override
  List<Object?> get props => [id];
}

class TogglePaymentMethod extends PaymentMethodEvent {
  final int id;
  final bool isActive;
  const TogglePaymentMethod(this.id, this.isActive);
  @override
  List<Object?> get props => [id, isActive];
}

class ToggleFixPayment extends PaymentMethodEvent {
  final int id;
  final bool isFixPayment;
  const ToggleFixPayment(this.id, this.isFixPayment);
  @override
  List<Object?> get props => [id, isFixPayment];
}
