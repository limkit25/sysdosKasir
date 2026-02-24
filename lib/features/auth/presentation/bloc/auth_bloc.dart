import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

// --- Events ---

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

// --- States ---

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AuthPasswordChangeSuccess extends AuthState {
  final User user;
  const AuthPasswordChangeSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthPasswordChangeFailure extends AuthState {
  final String message;
  final User user;
  const AuthPasswordChangeFailure(this.message, this.user);

  @override
  List<Object> get props => [message, user];
}

// --- Bloc ---

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    final result = await _authRepository.login(event.email, event.password);
    
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final result = await _authRepository.getCurrentUser();
    
    result.fold(
      (failure) => emit(AuthInitial()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(AuthInitial());
  }

  Future<void> _onChangePasswordRequested(ChangePasswordRequested event, Emitter<AuthState> emit) async {
    if (state is AuthAuthenticated) {
      final user = (state as AuthAuthenticated).user;
      
      final result = await _authRepository.changePassword(
        user.id,
        event.currentPassword,
        event.newPassword,
      );
      
      result.fold(
        (failure) {
          emit(AuthPasswordChangeFailure(failure.message, user));
          emit(AuthAuthenticated(user: user)); // Revert
        },
        (_) {
          emit(AuthPasswordChangeSuccess(user));
          emit(AuthAuthenticated(user: user)); // Revert
        },
      );
    }
  }
}
