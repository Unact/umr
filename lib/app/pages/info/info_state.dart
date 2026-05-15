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
  deleteStorageGroupCodeSuccess,
  findDeliveryStorageLoadNeedCreation,
  findDeliveryStorageLoadCreated
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.foundSaleOrder,
    this.foundSupply,
    this.foundCodeParent,
    this.deliveryStorageLoadFind,
    this.foundStorageGroupCode,
    this.createdDeliveryStorageLoad,
    this.markirovkaOrganizations = const [],
    this.user,
    this.message = ''
  });

  final InfoStateStatus status;
  final ApiSaleOrder? foundSaleOrder;
  final ApiSupply? foundSupply;
  final String? foundCodeParent;
  final ApiDeliveryStorageLoadFind? deliveryStorageLoadFind;
  final ApiStorageGroupCode? foundStorageGroupCode;
  final List<ApiMarkirovkaOrganization> markirovkaOrganizations;
  final ApiDeliveryStorageLoad? createdDeliveryStorageLoad;
  final String message;
  final User? user;

  InfoState copyWith({
    InfoStateStatus? status,
    ApiSaleOrder? foundSaleOrder,
    ApiSupply? foundSupply,
    String? foundCodeParent,
    ApiDeliveryStorageLoadFind? deliveryStorageLoadFind,
    ApiStorageGroupCode? foundStorageGroupCode,
    ApiDeliveryStorageLoad? createdDeliveryStorageLoad,
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
      deliveryStorageLoadFind: deliveryStorageLoadFind ?? this.deliveryStorageLoadFind,
      foundStorageGroupCode: foundStorageGroupCode ?? this.foundStorageGroupCode,
      createdDeliveryStorageLoad: createdDeliveryStorageLoad ?? this.createdDeliveryStorageLoad,
      markirovkaOrganizations: markirovkaOrganizations ?? this.markirovkaOrganizations,
      message: message ?? this.message,
      user: user ?? this.user
    );
  }
}
