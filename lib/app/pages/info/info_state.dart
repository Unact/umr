part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  dataLoaded,
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
    this.user,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final List<ApiMarkirovkaOrganization> markirovkaOrganizations;
  final SaleOrderScanType? type;
  final String message;
  final User? user;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    List<ApiMarkirovkaOrganization>? markirovkaOrganizations,
    ApiInfoScan? infoScan,
    SaleOrderScanType? type,
    User? user,
    String? message
  }) {
    return InfoState(
      status: status ?? this.status,
      foundSaleOrder: foundSaleOrder ?? this.foundSaleOrder,
      markirovkaOrganizations: markirovkaOrganizations ?? this.markirovkaOrganizations,
      type: type ?? this.type,
      message: message ?? this.message,
      user: user ?? this.user
    );
  }
}
