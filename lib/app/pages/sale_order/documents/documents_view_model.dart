part of 'documents_page.dart';

class DocumentsViewModel extends PageViewModel<DocumentsState, DocumentsStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;
  final SaleOrderViewModel saleOrderVm;

  DocumentsViewModel(
    this.saleOrdersRepository,
    this.saleOrderVm,
    {required List<ApiSaleOrderDocument> documents}
  ) : super(DocumentsState(documents: documents));

  @override
  DocumentsStateStatus get status => state.status;

  Future<void> printDocuments(String printerIdStr) async {
    final renewBarcode = RenewBarcode.parse(printerIdStr);

    if (renewBarcode == null || renewBarcode.intId == null) {
      emit(state.copyWith(status: DocumentsStateStatus.failure, message: 'Не удалось определить принтер'));
      return;
    }

    emit(state.copyWith(status: DocumentsStateStatus.inProgress));

    try {
      await saleOrdersRepository.printDocuments(saleOrderVm.state.saleOrder, renewBarcode.intId!);

      emit(state.copyWith(
        status: DocumentsStateStatus.success,
        message: 'Создано задание на печать'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: DocumentsStateStatus.failure, message: e.message));
    }
  }
}
