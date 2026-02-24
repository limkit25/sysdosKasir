import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/shift.dart';
import '../../../domain/repositories/shift_repository.dart';

// --- Events ---

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();

  @override
  List<Object> get props => [];
}

class CheckActiveShift extends ShiftEvent {}

class OpenShift extends ShiftEvent {
  final int userId;
  final int startingCash;
  final String? note;

  const OpenShift({required this.userId, required this.startingCash, this.note});

  @override
  List<Object> get props => [userId, startingCash, note ?? ''];
}

class CloseShift extends ShiftEvent {
  final int shiftId;
  final int actualEndingCash;
  final String? note;

  const CloseShift({required this.shiftId, required this.actualEndingCash, this.note});

  @override
  List<Object> get props => [shiftId, actualEndingCash, note ?? ''];
}

class LoadShifts extends ShiftEvent {}

// --- States ---

abstract class ShiftState extends Equatable {
  const ShiftState();
  
  @override
  List<Object> get props => [];
}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftActive extends ShiftState {
  final Shift shift;

  const ShiftActive(this.shift);

  @override
  List<Object> get props => [shift];
}

class ShiftNone extends ShiftState {}

class ShiftError extends ShiftState {
  final String message;

  const ShiftError(this.message);

  @override
  List<Object> get props => [message];
}

class ShiftClosedSuccess extends ShiftState {
  final Shift shift;

  const ShiftClosedSuccess(this.shift);

  @override
  List<Object> get props => [shift];
}

class ShiftsLoaded extends ShiftState {
  final List<Shift> shifts;

  const ShiftsLoaded(this.shifts);

  @override
  List<Object> get props => [shifts];
}

// --- Bloc ---

@injectable
class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final ShiftRepository _shiftRepository;

  ShiftBloc(this._shiftRepository) : super(ShiftInitial()) {
    on<CheckActiveShift>(_onCheckActiveShift);
    on<OpenShift>(_onOpenShift);
    on<CloseShift>(_onCloseShift);
    on<LoadShifts>(_onLoadShifts);
  }

  Future<void> _onCheckActiveShift(CheckActiveShift event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await _shiftRepository.getActiveShift();
    
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shift) {
        if (shift != null) {
          emit(ShiftActive(shift));
        } else {
          emit(ShiftNone());
        }
      },
    );
  }

  Future<void> _onOpenShift(OpenShift event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await _shiftRepository.openShift(event.userId, event.startingCash, event.note);
    
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shift) => emit(ShiftActive(shift)),
    );
  }

  Future<void> _onCloseShift(CloseShift event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await _shiftRepository.closeShift(event.shiftId, event.actualEndingCash, event.note);
    
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shift) => emit(ShiftClosedSuccess(shift)),
    );
  }

  Future<void> _onLoadShifts(LoadShifts event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await _shiftRepository.getShifts();
    
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shifts) => emit(ShiftsLoaded(shifts)),
    );
  }
}
