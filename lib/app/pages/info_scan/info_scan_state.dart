part of 'info_scan_page.dart';

enum InfoScanStateStatus {
  initial,
  newScan,
  inProgress,
  success,
  failure
}

class InfoScanState {
  InfoScanState({
    this.status = InfoScanStateStatus.initial,
    this.currentInfoScan,
    required this.markirovkaOrganization,
    this.message = ''
  });

  final InfoScanStateStatus status;
  final ApiMarkirovkaOrganization markirovkaOrganization;
  final ApiInfoScan? currentInfoScan;
  final String message;

  InfoScanState copyWith({
    InfoScanStateStatus? status,
    ({ApiInfoScan? value})? currentInfoScan,
    ApiMarkirovkaOrganization? markirovkaOrganization,
    String? message
  }) {
    return InfoScanState(
      status: status ?? this.status,
      currentInfoScan: currentInfoScan != null ? currentInfoScan.value : this.currentInfoScan,
      markirovkaOrganization: markirovkaOrganization ?? this.markirovkaOrganization,
      message: message ?? this.message
    );
  }
}
