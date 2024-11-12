part of 'scan_page.dart';

enum ScanStateStatus {
  initial,
  dataLoaded,
  inProgress,
  loadFailure,
  loadFinished,
  scanFailure,
  scanFinished
}

class ScanState {
  ScanState({
    this.status = ScanStateStatus.initial,
    this.codes = const [],
    this.message = ''
  });

  final ScanStateStatus status;
  final String message;
  final List<ApiCode> codes;

  ScanState copyWith({
    ScanStateStatus? status,
    List<ApiCode>? codes,
    String? message
  }) {
    return ScanState(
      status: status ?? this.status,
      codes: codes ?? this.codes,
      message: message ?? this.message
    );
  }
}
