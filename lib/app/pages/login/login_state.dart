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
    this.message = '',
    this.showCredentialsForm = false
  });

  final LoginStateStatus status;
  final String message;
  final bool showCredentialsForm;

  LoginState copyWith({
    LoginStateStatus? status,
    String? message,
    int? versionTapCnt,
    bool? showCredentialsForm
  }) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      showCredentialsForm: showCredentialsForm ?? this.showCredentialsForm
    );
  }
}
