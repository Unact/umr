part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  dataLoaded,
  inProgress,
  failure,
  findSaleOrderSuccess,
  findSupplySuccess,
  findCodeParentSuccess,
  printLabelSuccess,
  findDeliveryStorageLoadSuccess,
  findStorageGroupCodeSuccess,
  deleteStorageGroupCodeSuccess
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.foundSaleOrder,
    this.foundSupply,
    this.foundCodeParent,
    this.foundDeliveryStorageLoad,
    this.foundStorageGroupCode,
    this.markirovkaOrganizations = const [],
    this.user,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final ApiSupply? foundSupply;
  final String? foundCodeParent;
  final ApiDeliveryStorageLoad? foundDeliveryStorageLoad;
  final ApiStorageGroupCode? foundStorageGroupCode;
  final List<ApiMarkirovkaOrganization> markirovkaOrganizations;
  final String message;
  final User? user;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    ApiSupply? foundSupply,
    String? foundCodeParent,
    ApiDeliveryStorageLoad? foundDeliveryStorageLoad,
    ApiStorageGroupCode? foundStorageGroupCode,
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
      foundDeliveryStorageLoad: foundDeliveryStorageLoad ?? this.foundDeliveryStorageLoad,
      foundStorageGroupCode: foundStorageGroupCode ?? this.foundStorageGroupCode,
      markirovkaOrganizations: markirovkaOrganizations ?? this.markirovkaOrganizations,
      message: message ?? this.message,
      user: user ?? this.user
    );
  }
}
