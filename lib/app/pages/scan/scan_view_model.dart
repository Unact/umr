part of 'scan_page.dart';

class ScanViewModel extends PageViewModel<ScanState, ScanStateStatus> {
  final AppRepository appRepository;

  ScanViewModel(this.appRepository) : super(ScanState()) {
    loadScanData();
  }

  @override
  ScanStateStatus get status => state.status;

  Future<void> readCode(String? code) async {
    if (code == null) return;

    final formattedCode = code.substring(1);
    final codeFound = state.codes.firstWhereOrNull((e) => e.code == formattedCode) != null;

    emit(state.copyWith(
      status: codeFound ? ScanStateStatus.scanFinished : ScanStateStatus.scanFailure,
      message: codeFound ? 'КМ найден' : 'КМ не найден'
    ));
  }

  Future<void> loadScanData() async {
    emit(state.copyWith(status: ScanStateStatus.inProgress));

    try {
      final scanData = await appRepository.getScanData();

      emit(state.copyWith(status: ScanStateStatus.loadFinished, codes: scanData.codes));
    } on AppError catch(e) {
      emit(state.copyWith(status: ScanStateStatus.loadFailure, message: e.message));
    }
  }
}
