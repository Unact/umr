part of 'codes_page.dart';

class CodesViewModel extends PageViewModel<CodesState, CodesStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;

  StreamSubscription<List<SaleOrderLineCode>>? saleOrderLineCodesSubscription;

  CodesViewModel(this.saleOrdersRepository, { required ApiSaleOrder saleOrder, required SaleOrderScanType type}) :
    super(CodesState(saleOrder: saleOrder, type: type, confirmationCallback: () {}));

  @override
  CodesStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    saleOrderLineCodesSubscription = saleOrdersRepository.watchSaleOrderLineCodes(state.saleOrder.id).listen((event) {
      emit(state.copyWith(status: CodesStateStatus.dataLoaded, lineCodes: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await saleOrderLineCodesSubscription?.cancel();
  }

  Future<void> clearOrderLineCodes(ApiSaleOrderLine line) async {
    await saleOrdersRepository.clearSaleOrderLineCodes(saleOrder: state.saleOrder, line: line);
  }

  Future<void> clearGroupCodes(String groupCode) async {
    await saleOrdersRepository.clearSaleOrderLineCodes(groupCode: groupCode);
  }

  Future<void> startGroupScan(String code) async {
    emit(state.copyWith(
      status: CodesStateStatus.success,
      message: 'Начат режим агрегации кодов',
      currentGroupCode: (value: code)
    ));
  }

  Future<void> completeGroupScan() async {
    emit(state.copyWith(
      status: CodesStateStatus.success,
      message: 'Завершен режим агрегации кодов',
      currentGroupCode: (value: null)
    ));
  }

  Future<void> tryCompleteScan() async {
    if (state.type == SaleOrderScanType.correction) {
      emit(state.copyWith(
        status: CodesStateStatus.needUserConfirmation,
        message: 'Вы точно хотите завершить?',
        confirmationCallback: completeScan
      ));

      return;
    }

    await completeScan(true);
  }

  Future<void> completeScan(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: CodesStateStatus.inProgress));

    try {
      final saleOrder = await saleOrdersRepository.completeScan(state.saleOrder, state.type, state.lineCodes);
      await saleOrdersRepository.clearSaleOrderLineCodes(saleOrder: state.saleOrder);

      emit(state.copyWith(
        status: CodesStateStatus.success,
        saleOrder: saleOrder,
        message: 'Информация сохранена',
        finished: true
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: CodesStateStatus.failure, message: e.message));
    }
  }
}
