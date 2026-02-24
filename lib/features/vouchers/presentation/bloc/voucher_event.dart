import 'package:equatable/equatable.dart';
import '../../domain/entities/voucher.dart';

abstract class VoucherEvent extends Equatable {
  const VoucherEvent();
  @override
  List<Object?> get props => [];
}

class LoadVouchers extends VoucherEvent {}

class SaveVoucher extends VoucherEvent {
  final Voucher voucher;
  const SaveVoucher(this.voucher);
  @override
  List<Object?> get props => [voucher];
}

class UpdateVoucher extends VoucherEvent {
  final Voucher voucher;
  const UpdateVoucher(this.voucher);
  @override
  List<Object?> get props => [voucher];
}

class DeleteVoucher extends VoucherEvent {
  final int id;
  const DeleteVoucher(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleVoucherActive extends VoucherEvent {
  final int id;
  final bool isActive;
  const ToggleVoucherActive(this.id, this.isActive);
  @override
  List<Object?> get props => [id, isActive];
}
