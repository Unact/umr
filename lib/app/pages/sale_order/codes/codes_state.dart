part of 'codes_page.dart';

enum CodesStateStatus {
  initial,
  dataLoaded,
  inProgress,
  success,
  failure,
  needUserConfirmation
}

class CodesState {
  CodesState({
    this.status = CodesStateStatus.initial,
    required this.saleOrder,
    this.lineCodes = const [],
    required this.type,
    this.finished = false,
    this.message = '',
    this.currentGroupCode
  });

  final CodesStateStatus status;
  final ApiSaleOrder saleOrder;
  final List<SaleOrderLineCode> lineCodes;
  final SaleOrderScanType type;
  final String message;
  final bool finished;
  final String? currentGroupCode;

  bool get fullyScanned => lineCodes.fold(0.0, (prev, e) => prev + e.vol) ==
    saleOrder.lines.fold(0.0, (prev, e) => prev + e.vol);

  List<ApiSaleOrderLineCode> get allTypeLineCodes => saleOrder.allLineCodes.where((e) => e.type == type).toList();
  bool get allowEdit => !finished && allTypeLineCodes.isEmpty;

  CodesState copyWith({
    CodesStateStatus? status,
    ApiSaleOrder? saleOrder,
    List<SaleOrderLineCode>? lineCodes,
    SaleOrderScanType? type,
    bool? finished,
    String? message,
    ({String? value})? currentGroupCode
  }) {
    return CodesState(
      status: status ?? this.status,
      saleOrder: saleOrder ?? this.saleOrder,
      lineCodes: lineCodes ?? this.lineCodes,
      type: type ?? this.type,
      finished: finished ?? this.finished,
      message: message ?? this.message,
      currentGroupCode: currentGroupCode != null ? currentGroupCode.value : this.currentGroupCode
    );
  }
}
