part of 'storage_codes_page.dart';

class StorageCodesViewModel extends PageViewModel<StorageCodesState, StorageCodesStateStatus> {
  final AppRepository appRepository;
  final SaleOrdersRepository saleOrdersRepository;
  final SaleOrderViewModel saleOrderVm;

  StorageCodesViewModel(
    this.appRepository,
    this.saleOrdersRepository,
    this.saleOrderVm,
    {required List<ApiSaleOrderStorageLineCode> storageCodes}
  ) : super(StorageCodesState(storageCodes: storageCodes));

  @override
  StorageCodesStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();
  }

  Future<void> clearOrderLineCodes(ApiSaleOrderLine line) async {
    emit(state.copyWith(status: StorageCodesStateStatus.inProgress));

    try {
      final storageCodes = await saleOrdersRepository.deleteScan(saleOrderVm.state.saleOrder, line);

      emit(state.copyWith(
        status: StorageCodesStateStatus.success,
        storageCodes: storageCodes,
        message: 'КМ успешно удалены'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageCodesStateStatus.failure, message: e.message));
    }
  }

  Future<void> startGroupScan(String code) async {
    emit(state.copyWith(
      status: StorageCodesStateStatus.success,
      message: 'Начат режим агрегации кодов',
      currentGroupCode: (value: code)
    ));
  }

  Future<void> completeGroupScan() async {
    emit(state.copyWith(
      status: StorageCodesStateStatus.success,
      message: 'Завершен режим агрегации кодов',
      currentGroupCode: (value: null)
    ));
  }

  Future<void> scan(String code) async {
    try {
      final storageCodes = await saleOrdersRepository.scan(saleOrderVm.state.saleOrder, code, state.currentGroupCode);

      emit(state.copyWith(
        status: StorageCodesStateStatus.scanSuccess,
        storageCodes: storageCodes,
        message: 'КМ успешно отсканирован'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageCodesStateStatus.scanFailure, message: e.message));
    }
  }

  Future<void> tryCompleteScan() async {
    final scannedVol = state.storageCodes.fold(0.0, (v, el) => v + el.vol);
    final totalVol = saleOrderVm.state.saleOrder.lines.fold(0.0, (v, el) => v + el.vol);

    if (!saleOrderVm.state.saleOrder.status4 && scannedVol != totalVol) {
      emit(state.copyWith(
        status: StorageCodesStateStatus.needUserConfirmation,
        message: 'Количество отсканированного не равно количеству в заказе. Вы точно хотите завершить?'
      ));

      return;
    }

    await completeScan(true);
  }

  Future<void> completeScan(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: StorageCodesStateStatus.inProgress));

    try {
      final saleOrder = await saleOrdersRepository.completeScan(saleOrderVm.state.saleOrder);

      saleOrderVm.updateSaleOrder(saleOrder);

      emit(state.copyWith(status: StorageCodesStateStatus.success, message: 'Информация сохранена'));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageCodesStateStatus.failure, message: e.message));
    }
  }
}
