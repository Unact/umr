part of 'entities.dart';

class ApiSaleOrderDocument extends Equatable {
  final int id;
  final int pageCount;
  final String filename;

  const ApiSaleOrderDocument({
    required this.id,
    required this.pageCount,
    required this.filename
  });

  factory ApiSaleOrderDocument.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderDocument(
      id: json['id'],
      filename: json['filename'],
      pageCount: json['pageCount']
    );
  }

  @override
  List<Object?> get props => [
    id,
    pageCount,
    filename
  ];
}
