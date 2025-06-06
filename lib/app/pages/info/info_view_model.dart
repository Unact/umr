part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;
  final UsersRepository usersRepository;

  Timer? syncTimer;

  InfoViewModel(
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

  Future<void> findSaleOrder(String ndoc, SaleOrderScanType type) async {
    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      final saleOrder = await saleOrdersRepository.findSaleOrder(ndoc);

      emit(state.copyWith(status: InfoStateStatus.success, foundSaleOrder: saleOrder, type: type));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> clearSaleOrderLineCodes() async {
    await saleOrdersRepository.clearSaleOrderLineCodes();
  }
}
