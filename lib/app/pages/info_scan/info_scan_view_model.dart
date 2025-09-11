part of 'info_scan_page.dart';

class InfoScanViewModel extends PageViewModel<InfoScanState, InfoScanStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;

  InfoScanViewModel(this.saleOrdersRepository, { required ApiMarkirovkaOrganization markirovkaOrganization }) :
    super(InfoScanState(markirovkaOrganization: markirovkaOrganization));

  @override
  InfoScanStateStatus get status => state.status;

  void startNewScan() {
    emit(state.copyWith(status: InfoScanStateStatus.newScan, currentInfoScan: (value: null)));
  }

  Future<void> infoScan(String code) async {
    emit(state.copyWith(status: InfoScanStateStatus.inProgress));

    try {
      final infoScan = await saleOrdersRepository.infoScan(code, state.markirovkaOrganization);

      emit(state.copyWith(status: InfoScanStateStatus.success, currentInfoScan: (value: infoScan)));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoScanStateStatus.failure, message: e.message));
    }
  }
}
