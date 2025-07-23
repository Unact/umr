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
    final queryParameters = { 'code': code, 'markirovkaOrganizationId': markirovkaOrganizationId };

    return ApiInfoScan.fromJson(await get('v1/umr/sale_orders/info_scan', queryParameters: queryParameters));
  }

  Future<ApiSaleOrder> saleOrdersIndex({ required String ndoc }) async {
    return ApiSaleOrder.fromJson(await get('v1/umr/sale_orders', queryParameters: { 'ndoc': ndoc }));
  }

  Future<void> saleOrdersCompleteScan({
    required int saleOrderId,
    required int type,
    required List<Map<String, dynamic>> codes
  }) async {
    await post(
      'v1/umr/sale_orders/complete_scan',
      dataGenerator: () => { 'saleOrderId': saleOrderId, 'type': type, 'codes': codes }
    );
  }

  Future<ApiMarkirovkaCode> scan({
    required int saleOrderId,
    required int type,
    required String code
  }) async {
    return ApiMarkirovkaCode.fromJson(
      await get('v1/umr/sale_orders/scan', queryParameters: { 'saleOrderId': saleOrderId, 'type': type, 'code': code })
    );
  }
}
