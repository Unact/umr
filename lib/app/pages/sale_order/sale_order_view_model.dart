part of 'sale_order_page.dart';

class SaleOrderViewModel extends PageViewModel<SaleOrderState, SaleOrderStateStatus> {
  final SaleOrdersRepository saleOrdersRepository;

  SaleOrderViewModel(this.saleOrdersRepository, { required ApiSaleOrder saleOrder }) :
    super(SaleOrderState(saleOrder: saleOrder));

  @override
  SaleOrderStateStatus get status => state.status;
}
