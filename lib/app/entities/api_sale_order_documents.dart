part of 'entities.dart';

class ApiSaleOrderDocuments extends Equatable {
  final List<ApiSaleOrderDocument> documents;

  const ApiSaleOrderDocuments({
    required this.documents
  });

  factory ApiSaleOrderDocuments.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderDocuments(
      documents: json['documents'].map<ApiSaleOrderDocument>((e) => ApiSaleOrderDocument.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    documents
  ];
}
