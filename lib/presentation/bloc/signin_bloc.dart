import 'package:flutter_bloc/flutter_bloc.dart';
import 'signin_event.dart';
import 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInSubmitEvent>((event, emit) async {
      emit(SignInLoading()); // Show loading state

      // Simulate a delay (for authentication, replace with actual logic)
      await Future.delayed(const Duration(seconds: 2));

      // Check the username and password
      if (_validateCredentials(event.username, event.password)) {
        emit(SignInSuccess()); // If credentials are correct, show success state
      } else {
        emit(SignInError(message: 'Invalid username or password')); // If incorrect, show error
      }
    });
  }

  // A simple method to validate credentials (hardcoded for the task)
  bool _validateCredentials(String username, String password) {
    return username == 'user' && password == '123456';
  }
}
