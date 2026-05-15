
part of 'entities.dart';

class ApiDeliveryStorageLoadFind extends Equatable {
  final ApiDeliveryStorageLoad? deliveryStorageLoad;
  final int deliveryId;
  final bool needTruckScan;

  const ApiDeliveryStorageLoadFind({
    this.deliveryStorageLoad,
    required this.deliveryId,
    required this.needTruckScan
  });

  factory ApiDeliveryStorageLoadFind.fromJson(Map<String, dynamic> json) {
    return ApiDeliveryStorageLoadFind(
      deliveryStorageLoad: json['deliveryStorageLoad'] == null ?
        null :
        ApiDeliveryStorageLoad.fromJson(json['deliveryStorageLoad']),
      deliveryId: json['deliveryId'],
      needTruckScan: json['needTruckScan']
    );
  }

  @override
  List<Object?> get props => [
    deliveryStorageLoad,
    deliveryId,
    needTruckScan
  ];
}
