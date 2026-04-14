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
      final updatedStorageLoadSaleOrder = deliveryStorageLoad.deliveryStorageLoadSaleOrders
      .firstWhereOrNull((e) => e.ndoc == ndoc);

      emit(state.copyWith(
        status: DeliveryStorageLoadStateStatus.startLoadOrderSuccess,
        deliveryStorageLoad: deliveryStorageLoad,
        message: updatedStorageLoadSaleOrder!.warningMessage ?? 'Погрузка заказа успешно начата',
        showWarning: updatedStorageLoadSaleOrder.warningMessage != null
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

    if (state.deliveryStorageLoad.deliveryStorageLoadSaleOrders.any((e) => e.warningMessage != null)) {
      emit(state.copyWith(
        status: DeliveryStorageLoadStateStatus.needUserConfirmation,
        message: 'Присутствуют заказы с ошибками. Вы точно хотите завершить погрузку?'
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
        message: 'Погрузка успешно завершена',
        showWarning: false
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: DeliveryStorageLoadStateStatus.failure, message: e.message));
    }
  }
}
