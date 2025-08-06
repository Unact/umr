part of 'sale_order_page.dart';

class SaleOrderViewModel extends PageViewModel<SaleOrderState, SaleOrderStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;

  StreamSubscription<List<SaleOrderLineCode>>? saleOrderLineCodesSubscription;

  SaleOrderViewModel(this.saleOrdersRepository, { required ApiSaleOrder saleOrder, required SaleOrderScanType type}) :
    super(SaleOrderState(saleOrder: saleOrder, type: type, confirmationCallback: () {}));

  @override
  SaleOrderStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    saleOrderLineCodesSubscription = saleOrdersRepository.watchSaleOrderLineCodes(state.saleOrder.id).listen((event) {
      emit(state.copyWith(status: SaleOrderStateStatus.dataLoaded, lineCodes: event));
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

  Future<void> startGroupScan(String rawValue) async {
    final code = Formatter.formatScanValue(rawValue);

    emit(state.copyWith(
      status: SaleOrderStateStatus.success,
      message: 'Начат режим агрегации кодов',
      currentGroupCode: (value: code)
    ));
  }

  Future<void> completeGroupScan() async {
    emit(state.copyWith(
      status: SaleOrderStateStatus.success,
      message: 'Завершен режим агрегации кодов',
      currentGroupCode: (value: null)
    ));
  }

  Future<void> tryCompleteScan() async {
    if (state.type == SaleOrderScanType.correction) {
      emit(state.copyWith(
        status: SaleOrderStateStatus.needUserConfirmation,
        message: 'Вы точно хотите завершить?',
        confirmationCallback: completeScan
      ));

      return;
    }

    await completeScan(true);
  }

  Future<void> completeScan(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: SaleOrderStateStatus.inProgress));

    try {
      await saleOrdersRepository.completeScan(state.saleOrder, state.type, state.lineCodes);
      await saleOrdersRepository.clearSaleOrderLineCodes(saleOrder: state.saleOrder);

      emit(state.copyWith(
        status: SaleOrderStateStatus.success,
        message: 'Информация о доставке сохранена',
        finished: true
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: SaleOrderStateStatus.failure, message: e.message));
    }
  }
}
