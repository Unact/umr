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

    return ApiInfoScan.fromJson(await get('v2/umr/sale_orders/info_scan', query: query));
  }

  Future<ApiSaleOrder> saleOrdersIndex({ required String ndoc }) async {
    return ApiSaleOrder.fromJson(await get('v2/umr/sale_orders', query: { 'ndoc': ndoc }));
  }

  Future<ApiSaleOrderStorageLineCodes> saleOrderStorageCodesIndex({ required int saleOrderId }) async {
    return ApiSaleOrderStorageLineCodes.fromJson(
      await get('v2/umr/sale_orders/storage_codes', query: { 'saleOrderId': saleOrderId })
    );
  }

  Future<void> saleOrdersStorageCodesGroupScan({
    required int saleOrderId,
    required String groupCode
  }) async {
    await post(
      'v2/umr/sale_orders/storage_codes/group_scan',
      data: { 'saleOrderId': saleOrderId, 'groupCode': groupCode }
    );
  }

  Future<ApiSaleOrderStorageLineCodes> saleOrderStorageCodesScan({
    required int saleOrderId,
    required String code,
    required String? groupCode
  }) async {
    return ApiSaleOrderStorageLineCodes.fromJson(
      await post(
        'v2/umr/sale_orders/storage_codes/scan',
        data: { 'saleOrderId': saleOrderId, 'code': code, 'groupCode': groupCode }
      )
    );
  }

  Future<ApiSaleOrderStorageLineCodes> saleOrderStorageCodesDeleteScan({
    required int saleOrderId,
    required int saleOrderSubid
  }) async {
    return ApiSaleOrderStorageLineCodes.fromJson(
      await delete(
        'v2/umr/sale_orders/storage_codes/delete_scan',
        query: { 'saleOrderId': saleOrderId, 'saleOrderSubid': saleOrderSubid }
      )
    );
  }

  Future<ApiSaleOrder> saleOrdersStorageCodesCompleteScan({required int saleOrderId}) async {
    final result = await post(
      'v2/umr/sale_orders/storage_codes/complete_scan',
      data: { 'saleOrderId': saleOrderId }
    );

    return ApiSaleOrder.fromJson(result);
  }

  Future<ApiSaleOrderReturnStorageLineCodes> saleOrderReturnStorageCodesIndex({ required int saleOrderId }) async {
    return ApiSaleOrderReturnStorageLineCodes.fromJson(
      await get('v2/umr/sale_orders/return_storage_codes', query: { 'saleOrderId': saleOrderId })
    );
  }

  Future<ApiSaleOrderReturnStorageLineCodes> saleOrderReturnStorageCodesScan({
    required int saleOrderId,
    required String code
  }) async {
    return ApiSaleOrderReturnStorageLineCodes.fromJson(
      await post(
        'v2/umr/sale_orders/return_storage_codes/scan',
        data: { 'saleOrderId': saleOrderId, 'code': code }
      )
    );
  }

  Future<ApiSaleOrderReturnStorageLineCodes> saleOrderReturnStorageCodesDeleteScan({
    required int saleOrderId,
    required int saleOrderSubid
  }) async {
    return ApiSaleOrderReturnStorageLineCodes.fromJson(
      await delete(
        'v2/umr/sale_orders/return_storage_codes/delete_scan',
        query: { 'saleOrderId': saleOrderId, 'saleOrderSubid': saleOrderSubid }
      )
    );
  }

  Future<ApiSaleOrder> saleOrdersReturnStorageCodesCompleteScan({required int saleOrderId}) async {
    final result = await post(
      'v2/umr/sale_orders/return_storage_codes/complete_scan',
      data: { 'saleOrderId': saleOrderId }
    );

    return ApiSaleOrder.fromJson(result);
  }

  Future<ApiSaleOrderDocuments> saleOrderDocumentsIndex({
    required int saleOrderId
  }) async {
    return ApiSaleOrderDocuments.fromJson(
      await get('v2/umr/sale_orders/documents', query: { 'saleOrderId': saleOrderId })
    );
  }

  Future<void> saleOrdersDocumentsPrintAll({
    required int saleOrderId,
    required int printerId
  }) async {
    await post(
      'v2/umr/sale_orders/documents/print_all',
      data: { 'saleOrderId': saleOrderId, 'printerId': printerId }
    );
  }

  Future<ApiMarkirovkaCode> saleOrdersFindCodeParent({
    required String code
  }) async {
    return ApiMarkirovkaCode.fromJson(await get('v2/umr/sale_orders/find_code_parent', query: { 'code': code }));
  }

  Future<void> printCodeLabel({
    required String code,
    required int printerId
  }) async {
    await post('v1/umr/print_code_label', data: { 'code': code, 'printerId': printerId });
  }

  Future<void> printStorageGroupCodeLabels({
    required int count,
    required int printerId
  }) async {
    await post('v1/umr/print_storage_group_code_labels', data: { 'count': count, 'printerId': printerId });
  }

  Future<ApiSupply> suppliesIndex({ required int id }) async {
    return ApiSupply.fromJson(await get('v2/umr/supplies', query: { 'supplyId': id }));
  }

  Future<ApiSupplyStorageLineCodes> suppliesStorageCodesIndex({ required int supplyId }) async {
    return ApiSupplyStorageLineCodes.fromJson(
      await get('v2/umr/supplies/storage_codes', query: { 'supplyId': supplyId })
    );
  }

  Future<ApiSupplyStorageLineCodes> suppliesStorageCodesScan({
    required int supplyId,
    required String code,
    required bool onlyPiece
  }) async {
    return ApiSupplyStorageLineCodes.fromJson(
      await post(
        'v2/umr/supplies/storage_codes/scan',
        data: { 'supplyId': supplyId, 'code': code, 'onlyPiece': onlyPiece }
      )
    );
  }

  Future<ApiSupplyStorageLineCodes> suppliesStorageCodesDeleteScan({
    required int supplyId,
    required int supplySubid
  }) async {
    return ApiSupplyStorageLineCodes.fromJson(
      await delete(
        'v2/umr/supplies/storage_codes/delete_scan',
        query: { 'supplyId': supplyId, 'supplySubid': supplySubid }
      )
    );
  }

  Future<ApiSupply> suppliesStorageCodesCompleteScan({required int supplyId}) async {
    final result = await post(
      'v2/umr/supplies/storage_codes/complete_scan',
      data: { 'supplyId': supplyId }
    );

    return ApiSupply.fromJson(result);
  }

  Future<ApiDeliveryStorageLoadFind> deliveryStorageLoadsFind({ required String ndoc }) async {
    return ApiDeliveryStorageLoadFind.fromJson(
      await get('v1/umr/delivery_storage_loads/find', query: { 'ndoc': ndoc })
    );
  }

  Future<ApiDeliveryStorageLoad> deliveryStorageLoadsCreate({
    required int deliveryId,
    required int? truckId,
    required int warehouseGateId
  }) async {
    return ApiDeliveryStorageLoad.fromJson(
      await post(
        'v1/umr/delivery_storage_loads',
        data: { 'deliveryId': deliveryId, 'truckId': truckId, 'warehouseGateId': warehouseGateId  }
      )
    );
  }

  Future<ApiDeliveryStorageLoad> deliveryStorageLoadsStartLoadOrder({
    required int deliveryStorageLoadSaleOrderId
  }) async {
    return ApiDeliveryStorageLoad.fromJson(
      await post(
        'v1/umr/delivery_storage_loads/start_load_order',
        data: { 'deliveryStorageLoadSaleOrderId': deliveryStorageLoadSaleOrderId }
      )
    );
  }

  Future<ApiDeliveryStorageLoad> deliveryStorageLoadsCompleteDeliveryLoad({
    required int deliveryStorageLoadId
  }) async {
    return ApiDeliveryStorageLoad.fromJson(
      await post(
        'v1/umr/delivery_storage_loads/complete_delivery_load',
        data: { 'deliveryStorageLoadId': deliveryStorageLoadId }
      )
    );
  }

  Future<ApiStorageGroupCode> storageGroupCodesIndex({
    required String groupCode,
    required int markirovkaOrganizationId
  }) async {
    return ApiStorageGroupCode.fromJson(
      await get(
        'v1/umr/storage_group_codes',
        query: { 'groupCode': groupCode, 'markirovkaOrganizationId': markirovkaOrganizationId }
      )
    );
  }

  Future<ApiStorageGroupCode> storageGroupCodesScan({
    required int storageGroupCodeId,
    required String code
  }) async {
    return ApiStorageGroupCode.fromJson(
      await post(
        'v1/umr/storage_group_codes/scan',
        data: { 'storageGroupCodeId': storageGroupCodeId, 'code': code }
      )
    );
  }

  Future<ApiStorageGroupCode> storageGroupCodesDeleteScan({
    required int storageGroupCodeId,
    required String code
  }) async {
    return ApiStorageGroupCode.fromJson(
      await delete(
        'v1/umr/storage_group_codes/delete_scan',
        query: { 'storageGroupCodeId': storageGroupCodeId, 'code': code }
      )
    );
  }

  Future<ApiStorageGroupCode> storageGroupCodesCompleteScan({required int storageGroupCodeId}) async {
    final result = await post(
      'v1/umr/storage_group_codes/complete_scan',
      data: { 'storageGroupCodeId': storageGroupCodeId }
    );

    return ApiStorageGroupCode.fromJson(result);
  }

  Future<void> storageGroupCodesDelete({required String groupCode}) async {
    await delete('v1/umr/storage_group_codes', query: { 'groupCode': groupCode });
  }
}
