part of 'entities.dart';

class ApiInfoScanSaleOrder extends Equatable {
  final int id;
  final String ndoc;
  final SaleOrderScanType type;

  const ApiInfoScanSaleOrder({
    required this.id,
    required this.ndoc,
    required this.type
  });

  factory ApiInfoScanSaleOrder.fromJson(Map<String, dynamic> json) {
    return ApiInfoScanSaleOrder(
      id: json['id'],
      ndoc: json['ndoc'],
      type: SaleOrderScanType.values[json['type']]
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    type
  ];
}
