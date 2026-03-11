part of 'documents_page.dart';

enum DocumentsStateStatus {
  initial,
  dataLoaded,
  inProgress,
  success,
  failure
}

class DocumentsState {
  DocumentsState({
    this.status = DocumentsStateStatus.initial,
    required this.saleOrder,
    this.message = ''
  });

  final DocumentsStateStatus status;
  final ApiSaleOrder saleOrder;
  final String message;

  DocumentsState copyWith({
    DocumentsStateStatus? status,
    ApiSaleOrder? saleOrder,
    String? message,
  }) {
    return DocumentsState(
      status: status ?? this.status,
      saleOrder: saleOrder ?? this.saleOrder,
      message: message ?? this.message,
    );
  }
}
