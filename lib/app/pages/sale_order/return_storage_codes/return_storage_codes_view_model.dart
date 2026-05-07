part of 'return_storage_codes_page.dart';

class ReturnStorageCodesViewModel extends PageViewModel<ReturnStorageCodesState, ReturnStorageCodesStateStatus> {
  final AppRepository appRepository;
  final SaleOrdersRepository saleOrdersRepository;
  final SaleOrderViewModel saleOrderVm;

  ReturnStorageCodesViewModel(
    this.appRepository,
    this.saleOrdersRepository,
    this.saleOrderVm,
    {required List<ApiSaleOrderReturnStorageLineCode> returnStorageCodes}
  ) : super(ReturnStorageCodesState(returnStorageCodes: returnStorageCodes));

  @override
  ReturnStorageCodesStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();
  }

  Future<void> clearOrderLineCodes(ApiSaleOrderLine line) async {
     try {
      final returnStorageCodes = await saleOrdersRepository.deleteReturnScan(saleOrderVm.state.saleOrder, line);

      emit(state.copyWith(
        status: ReturnStorageCodesStateStatus.scanSuccess,
        returnStorageCodes: returnStorageCodes,
        message: 'КМ успешно удалены'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnStorageCodesStateStatus.scanFailure, message: e.message));
    }
  }

  Future<void> scan(String code) async {
    try {
      final returnStorageCodes = await saleOrdersRepository.returnScan(saleOrderVm.state.saleOrder, code);

      emit(state.copyWith(
        status: ReturnStorageCodesStateStatus.scanSuccess,
        returnStorageCodes: returnStorageCodes,
        message: 'КМ успешно отсканирован'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnStorageCodesStateStatus.scanFailure, message: e.message));
    }
  }

  Future<void> tryCompleteScan() async {
    emit(state.copyWith(
      status: ReturnStorageCodesStateStatus.needUserConfirmation,
      message: 'Вы точно хотите завершить?'
    ));
  }

  Future<void> completeScan(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: ReturnStorageCodesStateStatus.inProgress));

    try {
      final saleOrder = await saleOrdersRepository.completeReturnScan(saleOrderVm.state.saleOrder);

      saleOrderVm.updateSaleOrder(saleOrder);

      emit(state.copyWith(
        status: ReturnStorageCodesStateStatus.success,
        message: 'Информация сохранена',
        finished: true
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnStorageCodesStateStatus.failure, message: e.message));
    }
  }
}
