import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "📧 The email address is not valid.";
          break;
        case 'user-not-found':
          errorMessage = "👤 No user found for that email.";
          break;
        case 'wrong-password':
          errorMessage = "🔑 Incorrect password.";
          break;
        case 'invalid-credential':
          errorMessage = "❌Please fill correct email and password";
          break;
        default:
          errorMessage = "❌Please fill all fields";
        // errorMessage = "❌ ${e.code}";
      }
      emit(AuthFailure(errorMessage));
    } catch (_) {
      emit(AuthFailure("❌ Unknown login error."));
    }
  }

  Future<void> _onRegister(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "📧 Please enter a valid email address.";
          break;
        case 'email-already-in-use':
          errorMessage = "⚠️ Email already in use.";
          break;
        case 'weak-password':
          errorMessage = "🔒 Password must be at least 6 characters.";
          break;
        default:
          errorMessage = "❌Please fill all fields";
      }
      emit(AuthFailure(errorMessage));
    } catch (_) {
      emit(AuthFailure("❌ Unknown registration error."));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    emit(AuthInitial());
  }
}
