part of 'entities.dart';

class ApiDeliveryStorageLoadSaleOrder extends Equatable {
  final int id;
  final String ndoc;
  final DateTime? started;

  const ApiDeliveryStorageLoadSaleOrder({
    required this.id,
    required this.ndoc,
    required this.started
  });

  factory ApiDeliveryStorageLoadSaleOrder.fromJson(Map<String, dynamic> json) {
    return ApiDeliveryStorageLoadSaleOrder(
      id: json['id'],
      ndoc: json['ndoc'],
      started: Parsing.parseDate(json['started'])
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    started
  ];
}
