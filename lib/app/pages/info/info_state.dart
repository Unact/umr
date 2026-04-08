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
  findSupplySuccess,
  findCodeParentInProgress,
  findCodeParentFailure,
  findCodeParentSuccess,
  printCodeLabelInProgress,
  printCodeLabelSuccess,
  printCodeLabelFailure
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.foundSaleOrder,
    this.foundSupply,
    this.foundCodeParent,
    this.markirovkaOrganizations = const [],
    this.user,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final ApiSupply? foundSupply;
  final String? foundCodeParent;
  final List<ApiMarkirovkaOrganization> markirovkaOrganizations;
  final String message;
  final User? user;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    ApiSupply? foundSupply,
    String? foundCodeParent,
    List<ApiMarkirovkaOrganization>? markirovkaOrganizations,
    ApiInfoScan? infoScan,
    User? user,
    String? message
  }) {
    return InfoState(
      status: status ?? this.status,
      foundSaleOrder: foundSaleOrder ?? this.foundSaleOrder,
      foundSupply: foundSupply ?? this.foundSupply,
      foundCodeParent: foundCodeParent ?? this.foundCodeParent,
      markirovkaOrganizations: markirovkaOrganizations ?? this.markirovkaOrganizations,
      message: message ?? this.message,
      user: user ?? this.user
    );
  }
}
