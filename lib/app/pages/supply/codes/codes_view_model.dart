part of 'codes_page.dart';

class CodesViewModel extends PageViewModel<CodesState, CodesStateStatus> {
  final AppRepository appRepository;
  final SuppliesRepository suppliesRepository;

  StreamSubscription<List<SupplyLineCode>>? supplyLineCodesSubscription;

  CodesViewModel(this.appRepository, this.suppliesRepository, { required ApiSupply supply }) :
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
    await appRepository.transaction(() async {
      await suppliesRepository.clearSupplyLineCodes(supply: state.supply, line: line);
      await suppliesRepository.clearSupplyLineCodeDetails(supply: state.supply, line: line);
    });
  }

  Future<void> tryCompleteScan() async {
    if (!state.fullyScanned) {
      emit(state.copyWith(
        status: CodesStateStatus.needUserConfirmation,
        message: 'Отсканированы не все КМ из документа. Вы точно хотите завершить?',
        confirmationCallback: completeScan
      ));

      return;
    }

    await completeScan(true);
  }

  Future<void> completeScan(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: CodesStateStatus.inProgress));

    try {
      final supply = await appRepository.transaction(() async {
        final res = await suppliesRepository.completeScan(state.supply, state.lineCodes);
        await suppliesRepository.clearSupplyLineCodes(supply: state.supply);
        await suppliesRepository.clearSupplyLineCodeDetails(supply: state.supply);

        return res;
      });

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
