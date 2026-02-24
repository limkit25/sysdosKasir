import 'package:equatable/equatable.dart';

class Promo extends Equatable {
  final int? id;
  final String name;
  final String type; // 'percentage' or 'fixed'
  final int value;
  final bool isActive;
  final int minPurchase;
  final int maxDiscount;

  const Promo({
    this.id,
    required this.name,
    required this.type,
    required this.value,
    this.isActive = true,
    this.minPurchase = 0,
    this.maxDiscount = 0,
  });

  @override
  List<Object?> get props => [id, name, type, value, isActive, minPurchase, maxDiscount];
}
