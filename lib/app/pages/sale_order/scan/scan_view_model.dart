part of 'scan_page.dart';

class ScanViewModel extends PageViewModel<ScanState, ScanStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;

  StreamSubscription<List<SaleOrderLineCode>>? saleOrderLineCodesSubscription;

  ScanViewModel(
    this.saleOrdersRepository,
    {
      required ApiSaleOrder saleOrder,
      required SaleOrderScanType type,
      required String? groupCode
    }
  ) :
    super(ScanState(saleOrder: saleOrder, type: type, groupCode: groupCode));

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

  Future<void> readCode(String code) async {
    if (state.type == SaleOrderScanType.correction && state.saleOrder.lineCodes.any((e) => e.groupCode == code)) {
      state.saleOrder.lineCodes.where((e) => e.groupCode == code).forEach((e) async {
        if (state.lineCodes.any((lc) => lc.code == e.code)) return;

        await saleOrdersRepository.addSaleOrderLineCode(
          id: state.saleOrder.id,
          subid: e.subid,
          type: state.type,
          code: e.code,
          groupCode: e.groupCode,
          vol: e.vol,
          isTracking: e.isTracking
        );
      });

      emit(state.copyWith(status: ScanStateStatus.success, message: 'АК успешно отсканирован'));
      return;
    }

    try {
      final codeInfo = await saleOrdersRepository.scan(state.saleOrder, state.type, code);

      if (codeInfo.vol == 0) {
        emit(state.copyWith(status: ScanStateStatus.failure, message: 'Отсканирован товар без вложенности'));
        return;
      }

      if (state.type != SaleOrderScanType.correction && state.groupCode == null && codeInfo.vol == 1) {
        emit(state.copyWith(
          status: ScanStateStatus.failure,
          message: 'КМ штук можно сканировать только в рамках АК'
        ));
        return;
      }

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

      if (
        (state.lineCodes.any((e) => e.isTracking && e.subid == availableLine.subid) && !codeInfo.isTracking) ||
        (state.lineCodes.any((e) => !e.isTracking && e.subid == availableLine.subid) && codeInfo.isTracking)
      ) {
        emit(state.copyWith(
          status: ScanStateStatus.failure,
          message: 'Для одной позиции не могут присутствать коды ОСУ и поэкземплярного учета одновременно'
        ));
        return;
      }

      await saleOrdersRepository.addSaleOrderLineCode(
        id: state.saleOrder.id,
        subid: availableLine.subid,
        type: state.type,
        code: codeInfo.code,
        groupCode: state.groupCode,
        vol: codeInfo.vol,
        isTracking: codeInfo.isTracking
      );

      emit(state.copyWith(status: ScanStateStatus.success, message: 'КМ успешно отсканирован'));
    } on AppError catch(e) {
      emit(state.copyWith(status: ScanStateStatus.failure, message: e.message));
    }
  }
}
