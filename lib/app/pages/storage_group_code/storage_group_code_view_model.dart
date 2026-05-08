part of 'storage_group_code_page.dart';

class StorageGroupCodeViewModel extends PageViewModel<StorageGroupCodeState, StorageGroupCodeStateStatus> {
  final StorageGroupCodesRepository storageGroupCodesRepository;

  StorageGroupCodeViewModel(
    this.storageGroupCodesRepository,
    { required ApiStorageGroupCode storageGroupCode }
  ) : super(StorageGroupCodeState(storageGroupCode: storageGroupCode));

  @override
  StorageGroupCodeStateStatus get status => state.status;

   Future<void> scan(String code) async {
    try {
      final storageGroupCode = await storageGroupCodesRepository.scan(state.storageGroupCode, code);

      emit(state.copyWith(
        status: StorageGroupCodeStateStatus.scanSuccess,
        storageGroupCode: storageGroupCode,
        message: 'КМ успешно отсканирован'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageGroupCodeStateStatus.scanFailure, message: e.message));
    }
  }

  Future<void> deleteScan(String code) async {
    try {
      final storageGroupCode = await storageGroupCodesRepository.deleteScan(state.storageGroupCode, code);

      emit(state.copyWith(
        status: StorageGroupCodeStateStatus.scanSuccess,
        storageGroupCode: storageGroupCode,
        message: 'КМ успешно удален'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageGroupCodeStateStatus.scanFailure, message: e.message));
    }
  }

  Future<void> completeScan() async {
    emit(state.copyWith(status: StorageGroupCodeStateStatus.inProgress));

     try {
      final storageGroupCode = await storageGroupCodesRepository.completeScan(state.storageGroupCode);

      emit(state.copyWith(
        status: StorageGroupCodeStateStatus.success,
        storageGroupCode: storageGroupCode,
        message: 'АК успешно сформирован'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: StorageGroupCodeStateStatus.failure, message: e.message));
    }
  }
}
