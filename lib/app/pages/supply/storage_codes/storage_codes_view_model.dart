part of 'storage_codes_page.dart';

class StorageCodesViewModel extends PageViewModel<StorageCodesState, StorageCodesStateStatus> {
  final SuppliesRepository suppliesRepository;
  final SupplyViewModel supplyVm;

  StorageCodesViewModel(
    this.suppliesRepository,
    this.supplyVm,
    { required List<ApiSupplyStorageLineCode> storageCodes }
  ) : super(StorageCodesState(storageCodes: storageCodes));

  @override
  StorageCodesStateStatus get status => state.status;

  Future<void> clearOrderLineCodes(ApiSupplyLine line) async {
    emit(state.copyWith(status: StorageCodesStateStatus.inProgress));

    try {
      final storageCodes = await suppliesRepository.deleteScan(supplyVm.state.supply, line);

      emit(state.copyWith(
        status: StorageCodesStateStatus.success,
        storageCodes: storageCodes,
        message: 'КМ успешно удалены'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageCodesStateStatus.failure, message: e.message));
    }
  }

  Future<void> scan(String code, bool onlyPiece) async {
    try {
      final storageCodes = await suppliesRepository.scan(supplyVm.state.supply, code, onlyPiece);

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
    final totalVol = supplyVm.state.supply.lines.fold(0.0, (v, el) => v + el.vol);

    if (scannedVol != totalVol) {
      emit(state.copyWith(
        status: StorageCodesStateStatus.needUserConfirmation,
        message: 'Отсканированы не все КМ из документа. Вы точно хотите завершить?'
      ));

      return;
    }

    await completeScan(true);
  }

  Future<void> completeScan(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: StorageCodesStateStatus.inProgress));

    try {
      final supply = await suppliesRepository.completeScan(supplyVm.state.supply);

      supplyVm.updateSupply(supply);

      emit(state.copyWith(status: StorageCodesStateStatus.success, message: 'Информация сохранена',
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageCodesStateStatus.failure, message: e.message));
    }
  }
}
