part of 'scan_page.dart';

class ScanViewModel extends PageViewModel<ScanState, ScanStateStatus> {
  final SuppliesRepository suppliesRepository;

  StreamSubscription<List<SupplyLineCode>>? supplyLineCodesSubscription;

  ScanViewModel(
    this.suppliesRepository,
    {
      required ApiSupply supply
    }
  ) :
    super(ScanState(supply: supply));

  @override
  ScanStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    supplyLineCodesSubscription = suppliesRepository.watchSupplyLineCodes(state.supply.id).listen((event) {
      emit(state.copyWith(status: ScanStateStatus.dataLoaded, lineCodes: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await supplyLineCodesSubscription?.cancel();
  }

  Future<void> readCode(String code) async {
    try {
      final codeInfo = await suppliesRepository.scan(state.supply, code);

      if (state.lineCodes.any((e) => e.code == codeInfo.code)) {
        emit(state.copyWith(status: ScanStateStatus.failure, message: 'Товар уже отсканирован'));
        return;
      }

      for (var supgoods in codeInfo.supgoods) {
        await suppliesRepository.addSupplyLineCode(
          id: state.supply.id,
          subid: supgoods.subid,
          code: codeInfo.code,
          vol: supgoods.vol
        );
      }

      emit(state.copyWith(status: ScanStateStatus.success, message: 'КМ успешно отсканирован'));
    } on AppError catch(e) {
      emit(state.copyWith(status: ScanStateStatus.failure, message: e.message));
    }
  }
}
