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
    this.lineCodes = const [],
  });

  final ScanStateStatus status;
  final String message;
  final ApiSupply supply;
  final List<SupplyLineCode> lineCodes;

  ScanState copyWith({
    ScanStateStatus? status,
    String? message,
    ApiSupply? supply,
    List<SupplyLineCode>? lineCodes,
  }) {
    return ScanState(
      status: status ?? this.status,
      message: message ?? this.message,
      supply: supply ?? this.supply,
      lineCodes: lineCodes ?? this.lineCodes,
    );
  }
}
