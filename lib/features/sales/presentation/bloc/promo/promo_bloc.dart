import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/promo_repository.dart';
import 'promo_event.dart';
import 'promo_state.dart';

@injectable
class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository repository;

  PromoBloc(this.repository) : super(PromoInitial()) {
    on<LoadPromos>(_onLoadPromos);
    on<AddPromo>(_onAddPromo);
    on<UpdatePromo>(_onUpdatePromo);
    on<DeletePromo>(_onDeletePromo);
  }

  Future<void> _onLoadPromos(LoadPromos event, Emitter<PromoState> emit) async {
    emit(PromoLoading());
    final result = await repository.getPromos();
    result.fold(
      (failure) => emit(PromoError(failure.message)),
      (promos) => emit(PromoLoaded(promos)),
    );
  }

  Future<void> _onAddPromo(AddPromo event, Emitter<PromoState> emit) async {
    emit(PromoLoading());
    final result = await repository.addPromo(event.promo);
    result.fold(
      (failure) => emit(PromoError(failure.message)),
      (_) {
        emit(const PromoOperationSuccess('Promo Added'));
        add(LoadPromos());
      },
    );
  }

  Future<void> _onUpdatePromo(UpdatePromo event, Emitter<PromoState> emit) async {
    emit(PromoLoading());
    final result = await repository.updatePromo(event.promo);
    result.fold(
      (failure) => emit(PromoError(failure.message)),
      (_) {
        emit(const PromoOperationSuccess('Promo Updated'));
        add(LoadPromos());
      },
    );
  }

  Future<void> _onDeletePromo(DeletePromo event, Emitter<PromoState> emit) async {
    emit(PromoLoading());
    final result = await repository.deletePromo(event.id);
    result.fold(
      (failure) => emit(PromoError(failure.message)),
      (_) {
        emit(const PromoOperationSuccess('Promo Deleted'));
        add(LoadPromos());
      },
    );
  }
}
