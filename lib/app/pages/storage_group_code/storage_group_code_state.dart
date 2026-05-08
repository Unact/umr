part of 'storage_group_code_page.dart';

enum StorageGroupCodeStateStatus {
  initial,
  inProgress,
  failure,
  success,
  scanFailure,
  scanSuccess
}

class StorageGroupCodeState {
  StorageGroupCodeState({
    this.status = StorageGroupCodeStateStatus.initial,
    required this.storageGroupCode,
    this.message = ''
  });

  final StorageGroupCodeStateStatus status;
  final ApiStorageGroupCode storageGroupCode;
  final String message;

  StorageGroupCodeState copyWith({
    StorageGroupCodeStateStatus? status,
    ApiStorageGroupCode? storageGroupCode,
    String? message
  }) {
    return StorageGroupCodeState(
      status: status ?? this.status,
      storageGroupCode: storageGroupCode ?? this.storageGroupCode,
      message: message ?? this.message,
    );
  }
}
