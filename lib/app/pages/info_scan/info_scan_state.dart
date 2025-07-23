part of 'info_scan_page.dart';

enum InfoScanStateStatus {
  initial
}

class InfoScanState {
  InfoScanState({
    this.status = InfoScanStateStatus.initial,
    required this.infoScan,
  });

  final InfoScanStateStatus status;
  final ApiInfoScan infoScan;


  InfoScanState copyWith({
    InfoScanStateStatus? status,
    ApiInfoScan? infoScan
  }) {
    return InfoScanState(
      status: status ?? this.status,
      infoScan: infoScan ?? this.infoScan
    );
  }
}
