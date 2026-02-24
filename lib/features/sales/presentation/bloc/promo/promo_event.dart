import 'package:equatable/equatable.dart';
import '../../../domain/entities/promo.dart';

abstract class PromoEvent extends Equatable {
  const PromoEvent();
  @override
  List<Object?> get props => [];
}

class LoadPromos extends PromoEvent {}

class AddPromo extends PromoEvent {
  final Promo promo;
  const AddPromo(this.promo);
  @override
  List<Object?> get props => [promo];
}

class UpdatePromo extends PromoEvent {
  final Promo promo;
  const UpdatePromo(this.promo);
  @override
  List<Object?> get props => [promo];
}

class DeletePromo extends PromoEvent {
  final int id;
  const DeletePromo(this.id);
  @override
  List<Object?> get props => [id];
}
