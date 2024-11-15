part of 'scan_page.dart';

class ScanViewModel extends PageViewModel<ScanState, ScanStateStatus> {
  final AppRepository appRepository;

  ScanViewModel(this.appRepository) : super(ScanState());

  @override
  ScanStateStatus get status => state.status;

  Future<void> readCode(String? code) async {
    if (code == null) return;

    try {
      await appRepository.scan(code: code);

      emit(state.copyWith(status: ScanStateStatus.scanSuccess, message: 'КМ найден'));
    } on AppError catch(e) {
      emit(state.copyWith(status: ScanStateStatus.scanFailure, message: e.message));
    }
  }
}
