import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/voucher_repository.dart';
import 'voucher_event.dart';
import 'voucher_state.dart';

@injectable
class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository repository;

  VoucherBloc(this.repository) : super(VoucherInitial()) {
    on<LoadVouchers>(_onLoadVouchers);
    on<SaveVoucher>(_onSaveVoucher);
    on<UpdateVoucher>(_onUpdateVoucher);
    on<DeleteVoucher>(_onDeleteVoucher);
    on<ToggleVoucherActive>(_onToggleVoucherActive);
  }

  Future<void> _onLoadVouchers(LoadVouchers event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    final result = await repository.getVouchers();
    result.fold(
      (failure) => emit(VoucherError(failure.message)),
      (vouchers) => emit(VoucherLoaded(vouchers)),
    );
  }

  Future<void> _onSaveVoucher(SaveVoucher event, Emitter<VoucherState> emit) async {
    final result = await repository.saveVoucher(event.voucher);
    result.fold(
      (failure) => emit(VoucherError(failure.message)),
      (_) => add(LoadVouchers()),
    );
  }

  Future<void> _onUpdateVoucher(UpdateVoucher event, Emitter<VoucherState> emit) async {
    final result = await repository.updateVoucher(event.voucher);
    result.fold(
      (failure) => emit(VoucherError(failure.message)),
      (_) => add(LoadVouchers()),
    );
  }

  Future<void> _onDeleteVoucher(DeleteVoucher event, Emitter<VoucherState> emit) async {
    final result = await repository.deleteVoucher(event.id);
    result.fold(
      (failure) => emit(VoucherError(failure.message)),
      (_) => add(LoadVouchers()),
    );
  }

  Future<void> _onToggleVoucherActive(ToggleVoucherActive event, Emitter<VoucherState> emit) async {
    final result = await repository.toggleActive(event.id, event.isActive);
    result.fold(
      (failure) => emit(VoucherError(failure.message)),
      (_) => add(LoadVouchers()),
    );
  }
}
