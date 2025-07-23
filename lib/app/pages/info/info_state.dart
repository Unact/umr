part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  showSaleOrderScan,
  showSaleOrderScanFailure,
  showInfoCodeScan,
  showInfoCodeScanFailure,
  findSaleOrderInProgress,
  findSaleOrderSuccess,
  findSaleOrderFailure,
  loadMarkirovkaOrganizationInProgress,
  loadMarkirovkaOrganizationSuccess,
  loadMarkirovkaOrganizationFailure,
  infoScanInProgress,
  infoScanSuccess,
  infoScanFailure
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.foundSaleOrder,
    this.markirovkaOrganizations = const [],
    this.infoScan,
    this.type,
    this.markirovkaOrganization,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final List<ApiMarkirovkaOrganization> markirovkaOrganizations;
  final ApiInfoScan? infoScan;
  final SaleOrderScanType? type;
  final ApiMarkirovkaOrganization? markirovkaOrganization;
  final String message;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    List<ApiMarkirovkaOrganization>? markirovkaOrganizations,
    ApiInfoScan? infoScan,
    SaleOrderScanType? type,
    ApiMarkirovkaOrganization? markirovkaOrganization,
    String? message
  }) {
    return InfoState(
      status: status ?? this.status,
      foundSaleOrder: foundSaleOrder ?? this.foundSaleOrder,
      markirovkaOrganizations: markirovkaOrganizations ?? this.markirovkaOrganizations,
      infoScan: infoScan ?? this.infoScan,
      type: type ?? this.type,
      markirovkaOrganization: markirovkaOrganization ?? this.markirovkaOrganization,
      message: message ?? this.message
    );
  }
}
