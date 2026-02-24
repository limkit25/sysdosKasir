import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/purchasing_repository.dart';
import 'purchasing_event.dart';
import 'purchasing_state.dart';

@injectable
class PurchasingBloc extends Bloc<PurchasingEvent, PurchasingState> {
  final PurchasingRepository repository;

  PurchasingBloc(this.repository) : super(PurchasingInitial()) {
    on<LoadPurchases>(_onLoadPurchases);
    on<SubmitPurchase>(_onSubmitPurchase);
    on<LoadPurchaseItems>(_onLoadPurchaseItems);
  }

  Future<void> _onLoadPurchases(LoadPurchases event, Emitter<PurchasingState> emit) async {
    emit(PurchasingLoading());
    final result = await repository.getPurchases();
    result.fold(
      (failure) => emit(PurchasingFailure(failure.message)),
      (purchases) => emit(PurchasingLoaded(purchases)),
    );
  }

  Future<void> _onSubmitPurchase(SubmitPurchase event, Emitter<PurchasingState> emit) async {
    emit(PurchasingLoading());
    final result = await repository.createPurchase(event.purchase, event.items);
    result.fold(
      (failure) => emit(PurchasingFailure(failure.message)),
      (id) => emit(PurchasingSuccess(id)),
    );
  }

  Future<void> _onLoadPurchaseItems(LoadPurchaseItems event, Emitter<PurchasingState> emit) async {
    emit(PurchasingLoading());
    final result = await repository.getPurchaseItems(event.purchaseId);
    result.fold(
      (failure) => emit(PurchasingFailure(failure.message)),
      (items) => emit(PurchaseItemsLoaded(items)),
    );
  }
}
