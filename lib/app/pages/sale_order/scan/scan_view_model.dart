part of 'scan_page.dart';

class ScanViewModel extends PageViewModel<ScanState, ScanStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;

  StreamSubscription<List<SaleOrderLineCode>>? saleOrderLineCodesSubscription;

  ScanViewModel(this.saleOrdersRepository, {required ApiSaleOrder saleOrder, required SaleOrderScanType type}) :
    super(ScanState(saleOrder: saleOrder, type: type));

  @override
  ScanStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    saleOrderLineCodesSubscription = saleOrdersRepository.watchSaleOrderLineCodes(state.saleOrder.id).listen((event) {
      emit(state.copyWith(status: ScanStateStatus.dataLoaded, lineCodes: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await saleOrderLineCodesSubscription?.cancel();
  }

  Future<void> readCode(String rawValue) async {
    final code = Formatter.formatScanValue(rawValue);

    try {
      final codeInfo = await saleOrdersRepository.scan(state.saleOrder, code);

      final codeVols = state.lineCodes.fold({}, (prev, e) {
        prev[e.subid] = (prev[e.subid] ?? 0) + e.vol;
        return prev;
      });
      final availableLine = state.saleOrder.lines.where((e) => e.gtin == codeInfo.gtin).firstWhereOrNull((e) {
        if ((codeVols[e.subid] ?? 0) + codeInfo.vol <= e.vol) return true;
        return false;
      });

      if (state.lineCodes.any((e) => e.code == codeInfo.code)) {
        emit(state.copyWith(status: ScanStateStatus.failure, message: 'Товар уже отсканирован'));
        return;
      }

      if (availableLine == null) {
        final goodsName = state.saleOrder.lines.firstWhereOrNull((e) => e.gtin == codeInfo.gtin)?.goodsName;

        if (goodsName != null) {
          emit(state.copyWith(
            status: ScanStateStatus.failure,
            message: 'Позиция $goodsName уже полностью отсканирована'
          ));
        } else {
          emit(state.copyWith(
            status: ScanStateStatus.failure,
            message: 'Товар для КМ не найден'
          ));
        }

        return;
      }

      await saleOrdersRepository.addSaleOrderLineCode(
        id: state.saleOrder.id,
        subid: availableLine.subid,
        type: state.type,
        code: codeInfo.code,
        vol: codeInfo.vol,
        isTracking: codeInfo.isTracking
      );

      emit(state.copyWith(status: ScanStateStatus.success, message: 'КМ успешно отсканирован'));
    } on AppError catch(e) {
      emit(state.copyWith(status: ScanStateStatus.failure, message: e.message));
    }
  }
}
