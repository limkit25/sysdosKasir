import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../features/pos/domain/repositories/transaction_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TransactionRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await _repository.getTurnoverStats();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (stats) => emit(DashboardLoaded(stats)),
    );
  }
}
