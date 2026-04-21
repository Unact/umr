part of 'delivery_storage_load_page.dart';

enum DeliveryStorageLoadStateStatus {
  initial,
  dataLoaded,
  inProgress,
  failure,
  needUserConfirmation,
  startLoadOrderSuccess,
  completeDeliveryLoadSuccess
}

class DeliveryStorageLoadState {
  DeliveryStorageLoadState({
    this.status = DeliveryStorageLoadStateStatus.initial,
    required this.deliveryStorageLoad,
    this.message = ''
  });

  final DeliveryStorageLoadStateStatus status;
  final ApiDeliveryStorageLoad deliveryStorageLoad;
  final String message;

  bool get allStarted => deliveryStorageLoad.deliveryStorageLoadSaleOrders.every((e) => e.started != null);

  DeliveryStorageLoadState copyWith({
    DeliveryStorageLoadStateStatus? status,
    ApiDeliveryStorageLoad? deliveryStorageLoad,
    String? message
  }) {
    return DeliveryStorageLoadState(
      status: status ?? this.status,
      deliveryStorageLoad: deliveryStorageLoad ?? this.deliveryStorageLoad,
      message: message ?? this.message,
    );
  }
}
