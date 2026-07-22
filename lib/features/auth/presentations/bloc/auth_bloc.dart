import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kedai_ayam_nina/features/auth/domain/usecases/watch_auth.dart';
import 'package:meta/meta.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final WatchAuth watchAuth;
  final Logout logout;

  AuthBloc({required this.login, required this.logout, required this.watchAuth})
    : super(AuthInitial()) {
    watchAuth().listen((user) {
      add(AuthCheck(user: user));
    });
    on<AuthCheck>((event, emit) {
      if (event.user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    });
    on<AuthLogin>(_onAuthLogin);
    on<AuthLogout>(_onAuthLogout);
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    try {
      emit(AuthInProgress());
      await login(event.email, event.password);
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    try {
      emit(AuthInProgress());
      await logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
