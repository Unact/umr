part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final AppRepository appRepository;
  final SaleOrdersRepository saleOrdersRepository;
  final UsersRepository usersRepository;
  StreamSubscription<User>? userSubscription;

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

    userSubscription = usersRepository.watchUser().listen((event) {
      emit(state.copyWith(status: InfoStateStatus.dataLoaded, user: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    syncTimer?.cancel();
    await userSubscription?.cancel();
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

  Future<void> findSaleOrder(SaleOrderScanType type, String ndoc) async {
    emit(state.copyWith(status: InfoStateStatus.findSaleOrderInProgress));

    try {
      final saleOrder = await saleOrdersRepository.findSaleOrder(ndoc);

      emit(state.copyWith(status: InfoStateStatus.findSaleOrderSuccess, foundSaleOrder: saleOrder, type: type));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.findSaleOrderFailure, message: e.message));
    }
  }

  Future<void> clearSaleOrderLineCodes() async {
    await saleOrdersRepository.clearSaleOrderLineCodes();
  }
}
