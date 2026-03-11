part of 'sale_order_page.dart';

enum SaleOrderStateStatus {
  initial,
  dataLoaded
}

class SaleOrderState {
  SaleOrderState({
    this.status = SaleOrderStateStatus.initial,
    required this.saleOrder
  });

  final SaleOrderStateStatus status;
  final ApiSaleOrder saleOrder;

  SaleOrderState copyWith({
    SaleOrderStateStatus? status,
    ApiSaleOrder? saleOrder
  }) {
    return SaleOrderState(
      status: status ?? this.status,
      saleOrder: saleOrder ?? this.saleOrder
    );
  }
}
