import 'package:equatable/equatable.dart';

class Voucher extends Equatable {
  final int? id;
  final String name;
  final int amount;
  final bool isActive;
  final DateTime createdDate;

  const Voucher({
    this.id,
    required this.name,
    required this.amount,
    this.isActive = true,
    required this.createdDate,
  });

  Voucher copyWith({
    int? id,
    String? name,
    int? amount,
    bool? isActive,
    DateTime? createdDate,
  }) {
    return Voucher(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  List<Object?> get props => [id, name, amount, isActive, createdDate];

  @override
  String toString() => 'Voucher(id: $id, name: $name, amount: $amount, isActive: $isActive)';
}
