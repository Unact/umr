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
    required this.saleOrder,
    this.lineCodes = const [],
    required this.type
  });

  final ScanStateStatus status;
  final String message;
  final ApiSaleOrder saleOrder;
  final List<SaleOrderLineCode> lineCodes;
  final SaleOrderScanType type;

  ScanState copyWith({
    ScanStateStatus? status,
    String? message,
    ApiSaleOrder? saleOrder,
    List<SaleOrderLineCode>? lineCodes,
    SaleOrderScanType? type
  }) {
    return ScanState(
      status: status ?? this.status,
      message: message ?? this.message,
      saleOrder: saleOrder ?? this.saleOrder,
      lineCodes: lineCodes ?? this.lineCodes,
      type: type ?? this.type,
    );
  }
}
