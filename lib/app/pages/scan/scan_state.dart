part of 'scan_page.dart';

enum ScanStateStatus {
  initial,
  dataLoaded,
  scanSuccess,
  scanFailure
}

class ScanState {
  ScanState({
    this.status = ScanStateStatus.initial,
    this.message = ''
  });

  final ScanStateStatus status;
  final String message;

  ScanState copyWith({
    ScanStateStatus? status,
    String? message
  }) {
    return ScanState(
      status: status ?? this.status,
      message: message ?? this.message
    );
  }
}
