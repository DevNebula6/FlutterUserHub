import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../auth models/auth_response.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  
  AuthBloc({required AuthService authService}) 
      : _authService = authService,
        super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }
  
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          final List<String?> token = await _authService.getToken();
          emit(Authenticated(
            user: user, 
            accessToken: token[0]!,
            refreshToken: token[1]!,
            ));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try {
      final AuthResponse response = await _authService.login(
        event.username,
        event.password
      );
      print("AUTH RESPONSE: ${response.toJson()}");
      if (response.success && response.user != null) {
          print("AUTH SUCCESS: ${response.user!.username}");
        emit(Authenticated(
          user: response.user!,
          accessToken: response.accessToken ?? '',
          refreshToken: response.refreshToken ?? '',
        ));
      } else {
        emit(AuthError(response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try {
      await _authService.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
