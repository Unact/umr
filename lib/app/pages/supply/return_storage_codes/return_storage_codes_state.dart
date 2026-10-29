part of 'return_storage_codes_page.dart';

enum ReturnStorageCodesStateStatus {
  initial,
  dataLoaded,
  inProgress,
  success,
  failure,
  scanSuccess,
  scanFailure,
  needUserConfirmation,
}

class ReturnStorageCodesState {
  ReturnStorageCodesState({
    this.status = ReturnStorageCodesStateStatus.initial,
    this.returnStorageCodes = const [],
    this.finished = false,
    this.message = ''
  });

  final ReturnStorageCodesStateStatus status;
  final List<ApiSupplyReturnStorageLineCode> returnStorageCodes;
  final String message;
  final bool finished;

  ReturnStorageCodesState copyWith({
    ReturnStorageCodesStateStatus? status,
    List<ApiSupplyReturnStorageLineCode>? returnStorageCodes,
    bool? finished,
    String? message
  }) {
    return ReturnStorageCodesState(
      status: status ?? this.status,
      returnStorageCodes: returnStorageCodes ?? this.returnStorageCodes,
      finished: finished ?? this.finished,
      message: message ?? this.message
    );
  }
}
