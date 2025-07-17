part of 'entities.dart';

class ApiSaleOrder extends Equatable {
  final int id;
  final String ndoc;
  final String buyerName;
  final List<ApiSaleOrderLine> lines;
  final List<ApiSaleOrderLineCode> lineCodes;

  const ApiSaleOrder({
    required this.id,
    required this.ndoc,
    required this.buyerName,
    required this.lines,
    required this.lineCodes
  });

  factory ApiSaleOrder.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrder(
      id: json['id'],
      ndoc: json['ndoc'],
      buyerName: json['buyerName'],
      lines: json['lines'].map<ApiSaleOrderLine>((e) => ApiSaleOrderLine.fromJson(e)).toList(),
      lineCodes: json['lineCodes'].map<ApiSaleOrderLineCode>((e) => ApiSaleOrderLineCode.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    buyerName,
    lines,
    lineCodes
  ];
}
