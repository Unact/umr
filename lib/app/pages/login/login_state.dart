part of 'login_page.dart';

enum LoginStateStatus {
  initial,
  failure,
  inProgress,
  passwordSent,
  loggedIn
}

class LoginState {
  LoginState({
    this.status = LoginStateStatus.initial,
    this.login = '',
    this.password = '',
    this.message = ''
  });

  final String login;
  final String password;
  final LoginStateStatus status;
  final String message;

  LoginState copyWith({
    LoginStateStatus? status,
    String? login,
    String? password,
    String? message
  }) {
    return LoginState(
      status: status ?? this.status,
      login: login ?? this.login,
      password: password ?? this.password,
      message: message ?? this.message
    );
  }
}
