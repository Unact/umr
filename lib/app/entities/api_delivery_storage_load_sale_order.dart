part of 'entities.dart';

class ApiDeliveryStorageLoadSaleOrder extends Equatable {
  final int id;
  final String ndoc;
  final bool status4;
  final DateTime? started;

  const ApiDeliveryStorageLoadSaleOrder({
    required this.id,
    required this.ndoc,
    required this.status4,
    required this.started
  });

  factory ApiDeliveryStorageLoadSaleOrder.fromJson(Map<String, dynamic> json) {
    return ApiDeliveryStorageLoadSaleOrder(
      id: json['id'],
      ndoc: json['ndoc'],
      status4: json['status4'],
      started: Parsing.parseDate(json['started'])
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    status4,
    started
  ];
}
