import 'dart:async';

import 'package:u_app_utils/u_app_utils.dart';

import '/app/entities/entities.dart';

extension UmrApi on RenewApi {
  Future<ApiUserData> getUserData() async {
    return ApiUserData.fromJson(await get('v1/umr/user_info'));
  }

  Future<List<ApiMarkirovkaOrganization>> markirovkaOrganizations() async {
    return (await get('v1/umr/dictionaries/markirovka_organizations')).map<ApiMarkirovkaOrganization>(
      (e) => ApiMarkirovkaOrganization.fromJson(e)
    ).toList();
  }

  Future<ApiInfoScan> saleOrdersInfoScan({ required String code, required int markirovkaOrganizationId}) async {
    final query = { 'code': code, 'markirovkaOrganizationId': markirovkaOrganizationId };

    return ApiInfoScan.fromJson(await get('v1/umr/sale_orders/info_scan', query: query));
  }

  Future<ApiSaleOrder> saleOrdersIndex({ required String ndoc }) async {
    return ApiSaleOrder.fromJson(await get('v1/umr/sale_orders', query: { 'ndoc': ndoc }));
  }

  Future<ApiSaleOrder> saleOrdersCompleteScan({
    required int saleOrderId,
    required int type,
    required List<Map<String, dynamic>> codes
  }) async {
    final result = await post(
      'v1/umr/sale_orders/complete_scan',
      data: { 'saleOrderId': saleOrderId, 'type': type, 'codes': codes }
    );

    return ApiSaleOrder.fromJson(result);
  }

  Future<ApiMarkirovkaCode> saleOrdersScan({
    required int saleOrderId,
    required int type,
    required String code
  }) async {
    return ApiMarkirovkaCode.fromJson(
      await get('v1/umr/sale_orders/scan', query: { 'saleOrderId': saleOrderId, 'type': type, 'code': code })
    );
  }

  Future<void> saleOrdersPrintDocuments({
    required int saleOrderId,
    required int printerId
  }) async {
    await post(
      'v1/umr/sale_orders/print_documents',
      data: { 'saleOrderId': saleOrderId, 'printerId': printerId }
    );
  }

  Future<ApiSupply> suppliesIndex({ required int id }) async {
    return ApiSupply.fromJson(await get('v1/umr/supplies', query: { 'supplyId': id }));
  }

  Future<ApiSupply> suppliesCompleteScan({
    required int supplyId,
    required List<Map<String, dynamic>> codes
  }) async {
    final result = await post(
      'v1/umr/supplies/complete_scan',
      data: { 'supplyId': supplyId, 'codes': codes }
    );

    return ApiSupply.fromJson(result);
  }

  Future<ApiSupplyMarkirovkaCode> suppliesScan({
    required int supplyId,
    required String code
  }) async {
    return ApiSupplyMarkirovkaCode.fromJson(
      await get('v1/umr/supplies/scan', query: { 'supplyId': supplyId, 'code': code })
    );
  }
}
