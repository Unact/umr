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
    this.message = ''
  });

  final LoginStateStatus status;
  final String message;

  LoginState copyWith({
    LoginStateStatus? status,
    String? message,
    int? versionTapCnt
  }) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message
    );
  }
}
