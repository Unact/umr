part of 'return_storage_codes_page.dart';

class ReturnStorageCodesViewModel extends PageViewModel<ReturnStorageCodesState, ReturnStorageCodesStateStatus> {
  final AppRepository appRepository;
  final SuppliesRepository suppliesRepository;
  final SupplyViewModel supplyVm;

  ReturnStorageCodesViewModel(
    this.appRepository,
    this.suppliesRepository,
    this.supplyVm,
    {required List<ApiSupplyReturnStorageLineCode> returnStorageCodes}
  ) : super(ReturnStorageCodesState(returnStorageCodes: returnStorageCodes));

  @override
  ReturnStorageCodesStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();
  }

  Future<void> clearOrderLineCodes(ApiSupplyLine line) async {
    emit(state.copyWith(status: ReturnStorageCodesStateStatus.inProgress));

    try {
      final returnStorageCodes = await suppliesRepository.deleteReturnScan(supplyVm.state.supply, line);

      emit(state.copyWith(
        status: ReturnStorageCodesStateStatus.success,
        returnStorageCodes: returnStorageCodes,
        message: 'КМ успешно удалены'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: ReturnStorageCodesStateStatus.failure, message: e.message));
    }
  }

  Future<void> scan(String code) async {
    try {
      final returnStorageCodes = await suppliesRepository.returnScan(supplyVm.state.supply, code);

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
      final supply = await suppliesRepository.completeReturnScan(supplyVm.state.supply);

      supplyVm.updateSupply(supply);

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
