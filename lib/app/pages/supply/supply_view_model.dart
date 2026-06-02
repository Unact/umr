part of 'supply_page.dart';

class SupplyViewModel extends PageViewModel<SupplyState, SupplyStateStatus> {
  final SuppliesRepository suppliesRepository;

  SupplyViewModel(this.suppliesRepository, { required ApiSupply supply }) :
    super(SupplyState(supply: supply));

  @override
  SupplyStateStatus get status => state.status;

  void updateSupply(ApiSupply supply) {
    emit(state.copyWith(
      status: SupplyStateStatus.supplyUpdated,
      supply: supply
    ));
  }

  Future<void> loadStorageCodes() async {
    emit(state.copyWith(status: SupplyStateStatus.inProgress));

    try {
      final storageCodes = await suppliesRepository.findSupplyStorageCodes(state.supply);

      emit(state.copyWith(
        status: SupplyStateStatus.storageCodesLoaded,
        loadedStorageCodes: storageCodes
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: SupplyStateStatus.loadFailure, message: e.message));
    }
  }
}
