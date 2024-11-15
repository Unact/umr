part of 'login_page.dart';

enum LoginStateStatus {
  initial,
  failure,
  inProgress,
  passwordSent,
  loggedIn,
  urlFieldActivated
}

extension LoginStateStatusX on LoginStateStatus {
  bool get isInitial => this == LoginStateStatus.initial;
  bool get isFailure => this == LoginStateStatus.failure;
  bool get isInProgress => this == LoginStateStatus.inProgress;
  bool get isPasswordSent => this == LoginStateStatus.passwordSent;
  bool get isLoggedIn => this == LoginStateStatus.loggedIn;
  bool get isUrlFieldActivated => this == LoginStateStatus.urlFieldActivated;
}

class LoginState {
  LoginState({
    this.status = LoginStateStatus.initial,
    this.login = '',
    this.password = '',
    this.url = const String.fromEnvironment('UMR_RENEW_URL'),
    this.optsEnabled = false,
    this.message = ''
  });

  final String login;
  final String password;
  final String url;
  final bool optsEnabled;
  final LoginStateStatus status;
  final String message;

  LoginState copyWith({
    LoginStateStatus? status,
    String? login,
    String? password,
    String? url,
    bool? optsEnabled,
    String? message
  }) {
    return LoginState(
      status: status ?? this.status,
      login: login ?? this.login,
      password: password ?? this.password,
      url: url ?? this.url,
      optsEnabled: optsEnabled ?? this.optsEnabled,
      message: message ?? this.message
    );
  }
}
