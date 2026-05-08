part of 'sale_order_page.dart';

class SaleOrderViewModel extends PageViewModel<SaleOrderState, SaleOrderStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;

  SaleOrderViewModel(this.saleOrdersRepository, { required ApiSaleOrder saleOrder }) :
    super(SaleOrderState(saleOrder: saleOrder));

  @override
  SaleOrderStateStatus get status => state.status;

  void updateSaleOrder(ApiSaleOrder saleOrder) {
    emit(state.copyWith(
      status: SaleOrderStateStatus.saleOrderUpdated,
      saleOrder: saleOrder
    ));
  }

  Future<void> loadStorageCodes() async {
    emit(state.copyWith(status: SaleOrderStateStatus.inProgress));

    try {
      final storageCodes = await saleOrdersRepository.findSaleOrderStorageCodes(state.saleOrder);

      emit(state.copyWith(
        status: SaleOrderStateStatus.storageCodesLoaded,
        loadedStorageCodes: storageCodes
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: SaleOrderStateStatus.loadFailure, message: e.message));
    }
  }

  Future<void> loadReturnStorageCodes() async {
    emit(state.copyWith(status: SaleOrderStateStatus.inProgress));

    try {
      final returnStorageCodes = await saleOrdersRepository.findSaleOrderReturnStorageCodes(state.saleOrder);

      emit(state.copyWith(
        status: SaleOrderStateStatus.returnStorageCodesLoaded,
        loadedReturnStorageCodes: returnStorageCodes
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: SaleOrderStateStatus.loadFailure, message: e.message));
    }
  }

  Future<void> loadDocuments() async {
    emit(state.copyWith(status: SaleOrderStateStatus.inProgress));

    try {
      final loadedDocuments = await saleOrdersRepository.findSaleOrderDocuments(state.saleOrder);

      emit(state.copyWith(
        status: SaleOrderStateStatus.documentsLoaded,
        loadedDocuments: loadedDocuments
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: SaleOrderStateStatus.loadFailure, message: e.message));
    }
  }
}
