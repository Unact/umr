part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  dataLoaded,
  findSaleOrderInProgress,
  findSaleOrderSuccess,
  findSaleOrderFailure,
  loadMarkirovkaOrganizationInProgress,
  loadMarkirovkaOrganizationSuccess,
  loadMarkirovkaOrganizationFailure,
  findSupplyInProgress,
  findSupplyFailure,
  findSupplySuccess
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.foundSaleOrder,
    this.foundSupply,
    this.markirovkaOrganizations = const [],
    this.user,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final ApiSupply? foundSupply;
  final List<ApiMarkirovkaOrganization> markirovkaOrganizations;
  final String message;
  final User? user;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    ApiSupply? foundSupply,
    List<ApiMarkirovkaOrganization>? markirovkaOrganizations,
    ApiInfoScan? infoScan,
    User? user,
    String? message
  }) {
    return InfoState(
      status: status ?? this.status,
      foundSaleOrder: foundSaleOrder ?? this.foundSaleOrder,
      foundSupply: foundSupply ?? this.foundSupply,
      markirovkaOrganizations: markirovkaOrganizations ?? this.markirovkaOrganizations,
      message: message ?? this.message,
      user: user ?? this.user
    );
  }
}
