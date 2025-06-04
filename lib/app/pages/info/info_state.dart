part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  inProgress,
  success,
  failure
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.foundSaleOrder,
    this.type,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final SaleOrderScanType? type;
  final String message;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    SaleOrderScanType? type,
    String? message
  }) {
    return InfoState(
      status: status ?? this.status,
      foundSaleOrder: foundSaleOrder ?? this.foundSaleOrder,
      type: type ?? this.type,
      message: message ?? this.message
    );
  }
}
