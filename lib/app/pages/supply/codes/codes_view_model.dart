part of 'codes_page.dart';

class CodesViewModel extends PageViewModel<CodesState, CodesStateStatus> {
  final SuppliesRepository suppliesRepository;

  StreamSubscription<List<SupplyLineCode>>? supplyLineCodesSubscription;

  CodesViewModel(this.suppliesRepository, { required ApiSupply supply}) :
    super(CodesState(supply: supply, confirmationCallback: () {}));

  @override
  CodesStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    supplyLineCodesSubscription = suppliesRepository.watchSupplyLineCodes(state.supply.id).listen((event) {
      emit(state.copyWith(status: CodesStateStatus.dataLoaded, lineCodes: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await supplyLineCodesSubscription?.cancel();
  }

  Future<void> clearOrderLineCodes(ApiSupplyLine line) async {
    await suppliesRepository.clearSupplyLineCodes(supply: state.supply, line: line);
  }

  Future<void> completeScan() async {
    if (
      state.lineCodes.fold(0.0, (prev, e) => prev + e.vol) != state.supply.lines.fold(0.0, (prev, e) => prev + e.vol)
    ) {
      emit(state.copyWith(status: CodesStateStatus.failure, message: 'Не отсканированы все коды в поставке'));
      return;
    }

    emit(state.copyWith(status: CodesStateStatus.inProgress));

    try {
      final supply = await suppliesRepository.completeScan(state.supply, state.lineCodes);
      await suppliesRepository.clearSupplyLineCodes(supply: state.supply);

      emit(state.copyWith(
        status: CodesStateStatus.success,
        supply: supply,
        message: 'Информация сохранена',
        finished: true
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: CodesStateStatus.failure, message: e.message));
    }
  }
}
