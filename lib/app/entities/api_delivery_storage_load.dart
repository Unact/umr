part of 'entities.dart';

class ApiDeliveryStorageLoad extends Equatable {
  final int id;
  final String ndoc;
  final DateTime? started;
  final DateTime? finished;
  final List<ApiDeliveryStorageLoadSaleOrder> deliveryStorageLoadSaleOrders;

  const ApiDeliveryStorageLoad({
    required this.id,
    required this.ndoc,
    required this.started,
    required this.finished,
    required this.deliveryStorageLoadSaleOrders
  });

  factory ApiDeliveryStorageLoad.fromJson(Map<String, dynamic> json) {
    return ApiDeliveryStorageLoad(
      id: json['id'],
      ndoc: json['ndoc'],
      started: Parsing.parseDate(json['started']),
      finished: Parsing.parseDate(json['finished']),
      deliveryStorageLoadSaleOrders: json['deliveryStorageLoadSaleOrders']
        .map<ApiDeliveryStorageLoadSaleOrder>((e) => ApiDeliveryStorageLoadSaleOrder.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    started,
    finished,
    deliveryStorageLoadSaleOrders,
  ];
}
