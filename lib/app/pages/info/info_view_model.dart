part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final AppRepository appRepository;
  final DeliveryStorageLoadsRepository deliveryStorageLoadsRepository;
  final SaleOrdersRepository saleOrdersRepository;
  final StorageGroupCodesRepository storageGroupCodesRepository;
  final SuppliesRepository suppliesRepository;
  final UsersRepository usersRepository;
  StreamSubscription<User>? userSubscription;

  Timer? syncTimer;

  InfoViewModel(
    this.appRepository,
    this.deliveryStorageLoadsRepository,
    this.saleOrdersRepository,
    this.storageGroupCodesRepository,
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

    final markirovkaOrganizations = await appRepository.loadMarkirovkaOrganizations();

    emit(state.copyWith(status: InfoStateStatus.dataLoaded, markirovkaOrganizations: markirovkaOrganizations));
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

  Future<void> findSaleOrder(String ndoc) async {
    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      final saleOrder = await saleOrdersRepository.findSaleOrder(ndoc);

      emit(state.copyWith(status: InfoStateStatus.findSaleOrderSuccess, foundSaleOrder: saleOrder));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> clearLineCodes() async {
    await appRepository.transaction(() async {
      await suppliesRepository.clearSupplyLineCodes();
      await suppliesRepository.clearSupplyLineCodeDetails();
    });
  }

  Future<void> findSupply(String idStr) async {
    final id = int.tryParse(idStr);

    if (id == null) {
      emit(state.copyWith(
        status: InfoStateStatus.failure,
        message: 'Не удается распознать идентификатор'
      ));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      final supply = await suppliesRepository.findSupply(id);

      emit(state.copyWith(status: InfoStateStatus.findSupplySuccess, foundSupply: supply));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> findCodeParent(String code) async {
    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      final codeParent = (await saleOrdersRepository.findCodeParent(code)).code;

      emit(state.copyWith(status: InfoStateStatus.findCodeParentSuccess, foundCodeParent: codeParent));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> findDeliveryStorageLoad(String code) async {
    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      final deliveryStorageLoadFind = await deliveryStorageLoadsRepository.findDeliveryStorageLoad(code);

      emit(state.copyWith(
        status: InfoStateStatus.findDeliveryStorageLoadSuccess,
        deliveryStorageLoadFind: deliveryStorageLoadFind
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> createDeliveryStorageLoad(String warehouseGateStr, String? truckStr) async {
    final renewTruckBarcode = RenewBarcode.parse(truckStr ?? '');
    final renewWarehouseGateBarcode = RenewBarcode.parse(warehouseGateStr);

    if (renewWarehouseGateBarcode == null || renewWarehouseGateBarcode.intId == null) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: 'Не удалось определить ворота'));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      final createdDeliveryStorageLoad = await deliveryStorageLoadsRepository.createDeliveryStorageLoad(
        state.deliveryStorageLoadFind!.deliveryId,
        renewWarehouseGateBarcode.intId!,
        renewTruckBarcode?.intId
      );

      emit(state.copyWith(
        status: InfoStateStatus.findDeliveryStorageLoadCreated,
        createdDeliveryStorageLoad: createdDeliveryStorageLoad
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> findStorageGroupCode(String groupCode, ApiMarkirovkaOrganization markirovkaOrganization) async {
    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      final storageGroupCode = await storageGroupCodesRepository.findStorageGroupCode(
        groupCode,
        markirovkaOrganization
      );

      emit(state.copyWith(
        status: InfoStateStatus.findStorageGroupCodeSuccess,
        foundStorageGroupCode: storageGroupCode
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> deleteStorageGroupCode(String groupCode) async {
    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      await storageGroupCodesRepository.deleteStorageGroupCode(groupCode);

      emit(state.copyWith(status: InfoStateStatus.deleteStorageGroupCodeSuccess, message: 'АК успешно расформирован'));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> printCodeLabel(String printerIdStr) async {
    final renewBarcode = RenewBarcode.parse(printerIdStr);

    if (renewBarcode == null || renewBarcode.intId == null) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: 'Не удалось определить принтер'));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      await appRepository.printCodeLabel(state.foundCodeParent!, renewBarcode.intId!);

      emit(state.copyWith(
        status: InfoStateStatus.printLabelSuccess,
        message: 'Создано задание на печать'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }

  Future<void> printStorageGroupCodeLabels(int count, String printerIdStr) async {
    final renewBarcode = RenewBarcode.parse(printerIdStr);

    if (renewBarcode == null || renewBarcode.intId == null) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: 'Не удалось определить принтер'));
      return;
    }

    emit(state.copyWith(status: InfoStateStatus.inProgress));

    try {
      await appRepository.printStorageGroupCodeLabels(count, renewBarcode.intId!);

      emit(state.copyWith(
        status: InfoStateStatus.printLabelSuccess,
        message: 'Создано задание на печать'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message));
    }
  }
}
