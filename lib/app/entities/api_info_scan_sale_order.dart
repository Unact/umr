part of 'entities.dart';

class ApiInfoScanSaleOrder extends Equatable {
  final int id;
  final String ndoc;

  const ApiInfoScanSaleOrder({
    required this.id,
    required this.ndoc
  });

  factory ApiInfoScanSaleOrder.fromJson(Map<String, dynamic> json) {
    return ApiInfoScanSaleOrder(
      id: json['id'],
      ndoc: json['ndoc']
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc
  ];
}
