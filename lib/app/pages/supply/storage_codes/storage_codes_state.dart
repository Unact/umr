part of 'storage_codes_page.dart';

enum StorageCodesStateStatus {
  initial,
  dataLoaded,
  inProgress,
  success,
  failure,
  scanSuccess,
  scanFailure,
  needUserConfirmation
}

class StorageCodesState {
  StorageCodesState({
    this.status = StorageCodesStateStatus.initial,
    this.storageCodes = const [],
    this.message = ''
  });

  final StorageCodesStateStatus status;
  final List<ApiSupplyStorageLineCode> storageCodes;
  final String message;

  StorageCodesState copyWith({
    StorageCodesStateStatus? status,
    List<ApiSupplyStorageLineCode>? storageCodes,
    String? message
  }) {
    return StorageCodesState(
      status: status ?? this.status,
      storageCodes: storageCodes ?? this.storageCodes,
      message: message ?? this.message
    );
  }
}
