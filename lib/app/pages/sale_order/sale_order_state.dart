part of 'sale_order_page.dart';

enum SaleOrderStateStatus {
  initial,
  dataLoaded,
  inProgress,
  success,
  failure,
  showScan
}

class SaleOrderState {
  SaleOrderState({
    this.status = SaleOrderStateStatus.initial,
    required this.saleOrder,
    this.lineCodes = const [],
    required this.type,
    this.finished = false,
    this.message = ''
  });

  final SaleOrderStateStatus status;
  final ApiSaleOrder saleOrder;
  final List<SaleOrderLineCode> lineCodes;
  final SaleOrderScanType type;
  final String message;
  final bool finished;

  SaleOrderState copyWith({
    SaleOrderStateStatus? status,
    ApiSaleOrder? saleOrder,
    List<SaleOrderLineCode>? lineCodes,
    SaleOrderScanType? type,
    bool? finished,
    String? message
  }) {
    return SaleOrderState(
      status: status ?? this.status,
      saleOrder: saleOrder ?? this.saleOrder,
      lineCodes: lineCodes ?? this.lineCodes,
      type: type ?? this.type,
      finished: finished ?? this.finished,
      message: message ?? this.message,
    );
  }
}
