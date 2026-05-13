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
    this.message = '',
    this.currentGroupCode
  });

  final StorageCodesStateStatus status;
  final List<ApiSaleOrderStorageLineCode> storageCodes;
  final String message;
  final String? currentGroupCode;

  StorageCodesState copyWith({
    StorageCodesStateStatus? status,
    List<ApiSaleOrderStorageLineCode>? storageCodes,
    String? message,
    ({String? value})? currentGroupCode
  }) {
    return StorageCodesState(
      status: status ?? this.status,
      storageCodes: storageCodes ?? this.storageCodes,
      message: message ?? this.message,
      currentGroupCode: currentGroupCode != null ? currentGroupCode.value : this.currentGroupCode
    );
  }
}
