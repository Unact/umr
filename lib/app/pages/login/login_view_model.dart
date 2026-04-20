part of 'login_page.dart';

class LoginViewModel extends PageViewModel<LoginState, LoginStateStatus> {
  static final int kCredentialsFormTapCnt = 7;
  final UsersRepository usersRepository;

  LoginViewModel(this.usersRepository) : super(LoginState());

  @override
  LoginStateStatus get status => state.status;

  void processVersionTap(int tapCnt) {
    emit(state.copyWith(
      showCredentialsForm: tapCnt >= kCredentialsFormTapCnt
    ));
  }

  Future<void> apiUserTokenLogin(String userToken) async {
    if (userToken == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не удалось определить токен'));
      return;
    }

    emit(state.copyWith(status: LoginStateStatus.inProgress));

    try {
      await usersRepository.loginWithUserToken(userToken);

      emit(state.copyWith(status: LoginStateStatus.loggedIn));
    } on AppError catch(e) {
      emit(state.copyWith(status: LoginStateStatus.failure, message: e.message));
    }
  }

  Future<void> apiCredentialsLogin(String login, String password) async {
    login = _formatLogin(login);

    if (login == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не заполнено поле с логином'));
      return;
    }

    if (password == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не заполнено поле с паролем'));
      return;
    }

    emit(state.copyWith(status: LoginStateStatus.inProgress));

    try {
      await usersRepository.loginWithCredentials(login, password);

      emit(state.copyWith(status: LoginStateStatus.loggedIn));
    } on AppError catch(e) {
      emit(state.copyWith(status: LoginStateStatus.failure, message: e.message));
    }
  }

  Future<void> getNewPassword(String login) async {
    login = _formatLogin(login);

    if (login == '') {
      emit(state.copyWith(status: LoginStateStatus.failure, message: 'Не заполнено поле с логином'));
      return;
    }

    emit(state.copyWith(status: LoginStateStatus.inProgress));

    try {
      await usersRepository.resetPassword(login);
      emit(state.copyWith(status: LoginStateStatus.passwordSent, message: 'Пароль отправлен на почту'));
    } on AppError catch(e) {
      emit(state.copyWith(status: LoginStateStatus.failure, message: e.message));
    }
  }

  String _formatLogin(String login) {
    return login.replaceAll(RegExp(r'[+\s\(\)-]'), '').replaceFirst('7', '8');
  }
}
