part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  findSaleOrderInProgress,
  findSaleOrderSuccess,
  findSaleOrderFailure,
  loadMarkirovkaOrganizationInProgress,
  loadMarkirovkaOrganizationSuccess,
  loadMarkirovkaOrganizationFailure
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.foundSaleOrder,
    this.markirovkaOrganizations = const [],
    this.type,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final List<ApiMarkirovkaOrganization> markirovkaOrganizations;
  final SaleOrderScanType? type;
  final String message;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    List<ApiMarkirovkaOrganization>? markirovkaOrganizations,
    ApiInfoScan? infoScan,
    SaleOrderScanType? type,
    String? message
  }) {
    return InfoState(
      status: status ?? this.status,
      foundSaleOrder: foundSaleOrder ?? this.foundSaleOrder,
      markirovkaOrganizations: markirovkaOrganizations ?? this.markirovkaOrganizations,
      type: type ?? this.type,
      message: message ?? this.message
    );
  }
}
