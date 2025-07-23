part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final AppRepository appRepository;
  final SaleOrdersRepository saleOrdersRepository;
  final UsersRepository usersRepository;

  Timer? syncTimer;

  InfoViewModel(
    this.appRepository,
    this.saleOrdersRepository,
    this.usersRepository,
  ) : super(InfoState());

  @override
  InfoStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    await loadUserData();

    syncTimer = Timer.periodic(const Duration(minutes: 10), loadUserData);
  }

  @override
  Future<void> close() async {
    await super.close();

    syncTimer?.cancel();
  }

  Future<void> loadUserData([Timer? _]) async {
    try {
      await usersRepository.loadUserData();
    } on AppError catch(_) {}
  }

  Future<void> loadMarkirovkaOrganizations() async {
    emit(state.copyWith(status: InfoStateStatus.loadMarkirovkaOrganizationInProgress));
    try {
      final markirovkaOrganizations = await appRepository.loadMarkirovkaOrganizations();

      emit(state.copyWith(
        status: InfoStateStatus.loadMarkirovkaOrganizationSuccess,
        markirovkaOrganizations: markirovkaOrganizations
      ));

    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.loadMarkirovkaOrganizationFailure, message: e.message));
    }
  }

  void tryShowSaleOrderScan(SaleOrderScanType type) async {
    if (!await Permissions.hasCameraPermissions()) {
      emit(state.copyWith(
        message: 'Не разрешено использование камеры',
        status: InfoStateStatus.showSaleOrderScanFailure
      ));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.showSaleOrderScan, type: type));
  }

  void tryShowInfoCodeScan(ApiMarkirovkaOrganization markirovkaOrganization) async {
    if (!await Permissions.hasCameraPermissions()) {
      emit(state.copyWith(
        message: 'Не разрешено использование камеры',
        status: InfoStateStatus.showInfoCodeScanFailure
      ));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.showInfoCodeScan, markirovkaOrganization: markirovkaOrganization));
  }

  Future<void> findSaleOrder(String rawValue) async {
    final ndoc = Formatter.formatScanValue(rawValue);

    emit(state.copyWith(status: InfoStateStatus.findSaleOrderInProgress));

    try {
      final saleOrder = await saleOrdersRepository.findSaleOrder(ndoc);

      emit(state.copyWith(status: InfoStateStatus.findSaleOrderSuccess, foundSaleOrder: saleOrder));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.findSaleOrderFailure, message: e.message));
    }
  }

  Future<void> infoScan(String rawValue) async {
    final code = Formatter.formatScanValue(rawValue);

    emit(state.copyWith(status: InfoStateStatus.infoScanInProgress));

    try {
      final infoScan = await saleOrdersRepository.infoScan(code, state.markirovkaOrganization!);

      emit(state.copyWith(status: InfoStateStatus.infoScanSuccess, infoScan: infoScan));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.infoScanFailure, message: e.message));
    }
  }

  Future<void> clearSaleOrderLineCodes() async {
    await saleOrdersRepository.clearSaleOrderLineCodes();
  }
}
