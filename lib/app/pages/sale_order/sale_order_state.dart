part of 'sale_order_page.dart';

enum SaleOrderStateStatus {
  initial,
  dataLoaded,
  inProgress,
  success,
  failure,
  needUserConfirmation
}

class SaleOrderState {
  SaleOrderState({
    this.status = SaleOrderStateStatus.initial,
    required this.saleOrder,
    required this.confirmationCallback,
    this.lineCodes = const [],
    required this.type,
    this.finished = false,
    this.message = '',
    this.currentGroupCode
  });

  final SaleOrderStateStatus status;
  final ApiSaleOrder saleOrder;
  final Function confirmationCallback;
  final List<SaleOrderLineCode> lineCodes;
  final SaleOrderScanType type;
  final String message;
  final bool finished;
  final String? currentGroupCode;

  bool get fullyScanned => lineCodes.fold(0.0, (prev, e) => prev + e.vol) ==
    saleOrder.lines.fold(0.0, (prev, e) => prev + e.vol);

  SaleOrderState copyWith({
    SaleOrderStateStatus? status,
    ApiSaleOrder? saleOrder,
    Function? confirmationCallback,
    List<SaleOrderLineCode>? lineCodes,
    SaleOrderScanType? type,
    bool? finished,
    String? message,
    ({String? value})? currentGroupCode
  }) {
    return SaleOrderState(
      status: status ?? this.status,
      saleOrder: saleOrder ?? this.saleOrder,
      confirmationCallback: confirmationCallback ?? this.confirmationCallback,
      lineCodes: lineCodes ?? this.lineCodes,
      type: type ?? this.type,
      finished: finished ?? this.finished,
      message: message ?? this.message,
      currentGroupCode: currentGroupCode != null ? currentGroupCode.value : this.currentGroupCode
    );
  }
}
