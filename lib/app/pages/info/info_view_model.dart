part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final AppRepository appRepository;
  final SaleOrdersRepository saleOrdersRepository;
  final SuppliesRepository suppliesRepository;
  final UsersRepository usersRepository;
  StreamSubscription<User>? userSubscription;

  Timer? syncTimer;

  InfoViewModel(
    this.appRepository,
    this.saleOrdersRepository,
    this.suppliesRepository,
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

  Future<void> findSaleOrder(String ndoc) async {
    emit(state.copyWith(status: InfoStateStatus.findSaleOrderInProgress));

    try {
      final saleOrder = await saleOrdersRepository.findSaleOrder(ndoc);

      emit(state.copyWith(status: InfoStateStatus.findSaleOrderSuccess, foundSaleOrder: saleOrder));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.findSaleOrderFailure, message: e.message));
    }
  }

  Future<void> clearLineCodes() async {
    await appRepository.transaction(() async {
      await saleOrdersRepository.clearSaleOrderLineCodes();
      await suppliesRepository.clearSupplyLineCodes();
      await suppliesRepository.clearSupplyLineCodeDetails();
    });
  }

  Future<void> findSupply(String idStr) async {
    final id = int.tryParse(idStr);

    if (id == null) {
      emit(state.copyWith(
        status: InfoStateStatus.findSupplyFailure,
        message: 'Не удается распознать идентификатор'
      ));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.findSupplyInProgress));

    try {
      final supply = await suppliesRepository.findSupply(id);

      emit(state.copyWith(status: InfoStateStatus.findSupplySuccess, foundSupply: supply));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.findSupplyFailure, message: e.message));
    }
  }

  Future<void> findCodeParent(String code) async {
    emit(state.copyWith(status: InfoStateStatus.findCodeParentInProgress));

    try {
      final codeParent = (await saleOrdersRepository.findCodeParent(code)).code;

      emit(state.copyWith(status: InfoStateStatus.findCodeParentSuccess, foundCodeParent: codeParent));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.findCodeParentFailure, message: e.message));
    }
  }

  Future<void> printCodeLabel(String printerIdStr) async {
    int? printerId = int.tryParse(printerIdStr.split(' ').elementAtOrNull(1) ?? '');

    if (printerId == null) {
      emit(state.copyWith(status: InfoStateStatus.printCodeLabelFailure, message: 'Не удалось определить принтер'));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.printCodeLabelInProgress));

    try {
      await appRepository.printCodeLabel(state.foundCodeParent!, printerId);

      emit(state.copyWith(
        status: InfoStateStatus.printCodeLabelSuccess,
        message: 'Создано задание на печать'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.printCodeLabelFailure, message: e.message));
    }
  }
}
