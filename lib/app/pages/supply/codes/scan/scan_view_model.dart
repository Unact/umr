part of 'scan_page.dart';

class ScanViewModel extends PageViewModel<ScanState, ScanStateStatus> {
  final AppRepository appRepository;
  final SuppliesRepository suppliesRepository;

  StreamSubscription<List<SupplyLineCode>>? supplyLineCodesSubscription;
  StreamSubscription<List<SupplyLineCodeDetail>>? supplyLineCodeDetailsSubscription;

  ScanViewModel(
    this.appRepository,
    this.suppliesRepository,
    {
      required ApiSupply supply,
      required bool pieceScan
    }
  ) :
    super(ScanState(supply: supply, pieceScan: pieceScan));

  @override
  ScanStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    supplyLineCodesSubscription = suppliesRepository.watchSupplyLineCodes(state.supply.id).listen((event) {
      emit(state.copyWith(status: ScanStateStatus.dataLoaded, lineCodes: event));
    });
    supplyLineCodeDetailsSubscription = suppliesRepository.watchSupplyLineCodeDetails(state.supply.id).listen((event) {
      emit(state.copyWith(status: ScanStateStatus.dataLoaded, lineCodeDetails: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await supplyLineCodesSubscription?.cancel();
    await supplyLineCodeDetailsSubscription?.cancel();
  }

  Future<void> readCode(String code) async {
    try {
      if (state.lineCodes.any((e) => e.code == code)) {
        emit(state.copyWith(status: ScanStateStatus.failure, message: 'Товар уже отсканирован'));
        return;
      }

      final codeInfo = await suppliesRepository.scan(state.supply, code);

      if ((state.pieceScan && codeInfo.details.length != 1) || (!state.pieceScan && codeInfo.details.length == 1)) {
        emit(state.copyWith(
          status: ScanStateStatus.failure,
          message: 'Тип упаковки КМ не соответствует выбранному типу сканирования'
        ));
        return;
      }

      if (codeInfo.details.any((e) => state.lineCodeDetails.any((d) => d.cis == e.cis))) {
        emit(
          state.copyWith(status: ScanStateStatus.failure, message: 'Один из выше/ниже стоящих кодов уже отсканирован')
        );
        return;
      }

      await appRepository.transaction(() async {
        for (var supgoods in codeInfo.supgoods) {
          await suppliesRepository.addSupplyLineCode(
            id: state.supply.id,
            subid: supgoods.subid,
            code: codeInfo.code,
            vol: supgoods.vol
          );
          for (var detail in codeInfo.details) {
            await suppliesRepository.addSupplyLineCodeDetail(
              id: state.supply.id,
              subid: supgoods.subid,
              cis: detail.cis,
              parent: detail.parent,
              initiator: codeInfo.code
            );
          }
        }
      });

      emit(state.copyWith(status: ScanStateStatus.success, message: 'КМ успешно отсканирован'));
    } on AppError catch(e) {
      emit(state.copyWith(status: ScanStateStatus.failure, message: e.message));
    }
  }
}
