part of 'scan_page.dart';

enum ScanStateStatus {
  initial,
  dataLoaded,
  failure,
  success
}

class ScanState {
  ScanState({
    this.status = ScanStateStatus.initial,
    this.message = '',
    required this.supply,
    this.pieceScan = false,
    this.lineCodes = const [],
    this.lineCodeDetails = const [],
  });

  final ScanStateStatus status;
  final String message;
  final ApiSupply supply;
  final bool pieceScan;
  final List<SupplyLineCode> lineCodes;
  final List<SupplyLineCodeDetail> lineCodeDetails;

  ScanState copyWith({
    ScanStateStatus? status,
    String? message,
    ApiSupply? supply,
    bool? pieceScan,
    List<SupplyLineCode>? lineCodes,
    List<SupplyLineCodeDetail>? lineCodeDetails,
  }) {
    return ScanState(
      status: status ?? this.status,
      message: message ?? this.message,
      supply: supply ?? this.supply,
      pieceScan: pieceScan ?? this.pieceScan,
      lineCodes: lineCodes ?? this.lineCodes,
      lineCodeDetails: lineCodeDetails ?? this.lineCodeDetails,
    );
  }
}
