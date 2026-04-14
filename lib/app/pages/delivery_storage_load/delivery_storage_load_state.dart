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
    this.message = '',
    this.showWarning = false
  });

  final DeliveryStorageLoadStateStatus status;
  final ApiDeliveryStorageLoad deliveryStorageLoad;
  final String message;
  final bool showWarning;

  DeliveryStorageLoadState copyWith({
    DeliveryStorageLoadStateStatus? status,
    ApiDeliveryStorageLoad? deliveryStorageLoad,
    bool? showWarning,
    String? message
  }) {
    return DeliveryStorageLoadState(
      status: status ?? this.status,
      deliveryStorageLoad: deliveryStorageLoad ?? this.deliveryStorageLoad,
      message: message ?? this.message,
      showWarning: showWarning ?? this.showWarning
    );
  }
}
