// sign_in_event.dart
abstract class SignInEvent {}

class SignInSubmitEvent extends SignInEvent {
  final String username;
  final String password;

  SignInSubmitEvent({required this.username, required this.password});
}
