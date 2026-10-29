part of 'supply_page.dart';

enum SupplyStateStatus {
  initial,
  dataLoaded,
  supplyUpdated,
  inProgress,
  storageCodesLoaded,
  returnStorageCodesLoaded,
  loadFailure,
}

class SupplyState {
  SupplyState({
    this.status = SupplyStateStatus.initial,
    required this.supply,
    this.loadedStorageCodes = const [],
    this.loadedReturnStorageCodes = const [],
    this.message = ''
  });

  final SupplyStateStatus status;
  final ApiSupply supply;
  final List<ApiSupplyStorageLineCode> loadedStorageCodes;
  final List<ApiSupplyReturnStorageLineCode> loadedReturnStorageCodes;
  final String message;

  SupplyState copyWith({
    SupplyStateStatus? status,
    ApiSupply? supply,
    List<ApiSupplyStorageLineCode>? loadedStorageCodes,
    List<ApiSupplyReturnStorageLineCode>? loadedReturnStorageCodes,
    String? message,
  }) {
    return SupplyState(
      status: status ?? this.status,
      supply: supply ?? this.supply,
      loadedStorageCodes: loadedStorageCodes ?? this.loadedStorageCodes,
      loadedReturnStorageCodes: loadedReturnStorageCodes ?? this.loadedReturnStorageCodes,
      message: message ?? this.message
    );
  }
}
