part of 'entities.dart';

class ApiSaleOrder extends Equatable {
  final int id;
  final String ndoc;
  final String buyerName;
  final DateTime? scanned;
  final bool status4;
  final List<ApiSaleOrderLine> lines;

  const ApiSaleOrder({
    required this.id,
    required this.ndoc,
    required this.buyerName,
    this.scanned,
    required this.status4,
    required this.lines
  });

  factory ApiSaleOrder.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrder(
      id: json['id'],
      ndoc: json['ndoc'],
      buyerName: json['buyerName'],
      scanned: Parsing.parseDate(json['scanned']),
      status4: json['status4'],
      lines: json['lines'].map<ApiSaleOrderLine>((e) => ApiSaleOrderLine.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    buyerName,
    scanned,
    status4,
    lines,
  ];
}
