part of 'entities.dart';

class ApiDeliveryStorageLoadSaleOrder extends Equatable {
  final int id;
  final String ndoc;
  final DateTime? started;
  final String? warningMessage;

  const ApiDeliveryStorageLoadSaleOrder({
    required this.id,
    required this.ndoc,
    required this.started,
    required this.warningMessage
  });

  factory ApiDeliveryStorageLoadSaleOrder.fromJson(Map<String, dynamic> json) {
    return ApiDeliveryStorageLoadSaleOrder(
      id: json['id'],
      ndoc: json['ndoc'],
      started: Parsing.parseDate(json['started']),
      warningMessage: json['warningMessage']
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    started,
    warningMessage
  ];
}
