part of 'delivery_storage_load_page.dart';

class DeliveryStorageLoadViewModel extends PageViewModel<DeliveryStorageLoadState, DeliveryStorageLoadStateStatus> {
  final DeliveryStorageLoadsRepository deliveryStorageLoadsRepository;

  DeliveryStorageLoadViewModel(
    this.deliveryStorageLoadsRepository,
    { required ApiDeliveryStorageLoad deliveryStorageLoad }
  ) : super(DeliveryStorageLoadState(deliveryStorageLoad: deliveryStorageLoad));

  @override
  DeliveryStorageLoadStateStatus get status => state.status;

  Future<void> startLoadOrder(String ndoc) async {
    final storageLoadSaleOrder = state.deliveryStorageLoad.deliveryStorageLoadSaleOrders
      .firstWhereOrNull((e) => e.ndoc == ndoc);

    if (storageLoadSaleOrder == null) {
      emit(state.copyWith(
        status: DeliveryStorageLoadStateStatus.failure,
        message: 'Заказ не найден'
      ));
      return;
    }

    emit(state.copyWith(status: DeliveryStorageLoadStateStatus.inProgress));

     try {
      final deliveryStorageLoad = await deliveryStorageLoadsRepository.startLoadOrder(storageLoadSaleOrder);

      emit(state.copyWith(
        status: DeliveryStorageLoadStateStatus.startLoadOrderSuccess,
        deliveryStorageLoad: deliveryStorageLoad,
        message: 'Погрузка заказа успешно начата',
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: DeliveryStorageLoadStateStatus.failure, message: e.message));
    }
  }

  Future<void> tryCompleteDeliveryLoad() async {
    if (state.deliveryStorageLoad.deliveryStorageLoadSaleOrders.any((e) => e.started == null)) {
      emit(state.copyWith(
        status: DeliveryStorageLoadStateStatus.failure,
        message: 'Не все заказы загружены'
      ));
      return;
    }

    await completeDeliveryLoad(true);
  }

  Future<void> completeDeliveryLoad(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: DeliveryStorageLoadStateStatus.inProgress));

     try {
      final deliveryStorageLoad = await deliveryStorageLoadsRepository.completeDeliveryLoad(state.deliveryStorageLoad);

      emit(state.copyWith(
        status: DeliveryStorageLoadStateStatus.completeDeliveryLoadSuccess,
        deliveryStorageLoad: deliveryStorageLoad,
        message: 'Погрузка успешно завершена'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: DeliveryStorageLoadStateStatus.failure, message: e.message));
    }
  }
}
