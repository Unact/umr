part of 'sale_order_page.dart';

enum SaleOrderStateStatus {
  initial,
  dataLoaded,
  inProgress,
  storageCodesLoaded,
  returnStorageCodesLoaded,
  documentsLoaded,
  loadFailure,
  saleOrderUpdated
}

class SaleOrderState {
  SaleOrderState({
    this.status = SaleOrderStateStatus.initial,
    required this.saleOrder,
    this.loadedStorageCodes = const [],
    this.loadedReturnStorageCodes = const [],
    this.loadedDocuments = const [],
    this.message = ''
  });

  final SaleOrderStateStatus status;
  final ApiSaleOrder saleOrder;
  final List<ApiSaleOrderStorageLineCode> loadedStorageCodes;
  final List<ApiSaleOrderReturnStorageLineCode> loadedReturnStorageCodes;
  final List<ApiSaleOrderDocument> loadedDocuments;
  final String message;

  SaleOrderState copyWith({
    SaleOrderStateStatus? status,
    ApiSaleOrder? saleOrder,
    List<ApiSaleOrderStorageLineCode>? loadedStorageCodes,
    List<ApiSaleOrderReturnStorageLineCode>? loadedReturnStorageCodes,
    List<ApiSaleOrderDocument>? loadedDocuments,
    String? message,
  }) {
    return SaleOrderState(
      status: status ?? this.status,
      saleOrder: saleOrder ?? this.saleOrder,
      loadedStorageCodes: loadedStorageCodes ?? this.loadedStorageCodes,
      loadedReturnStorageCodes: loadedReturnStorageCodes ?? this.loadedReturnStorageCodes,
      loadedDocuments: loadedDocuments ?? this.loadedDocuments,
      message: message ?? this.message
    );
  }
}
