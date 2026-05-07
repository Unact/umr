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
    this.message = '',
    this.documents = const []
  });

  final DocumentsStateStatus status;
  final String message;
  final List<ApiSaleOrderDocument> documents;

  DocumentsState copyWith({
    DocumentsStateStatus? status,
    ApiSaleOrder? saleOrder,
    String? message,
    List<ApiSaleOrderDocument>? documents
  }) {
    return DocumentsState(
      status: status ?? this.status,
      message: message ?? this.message,
      documents: documents ?? this.documents,
    );
  }
}
