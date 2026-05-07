import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class SaleOrdersRepository extends BaseRepository {
  SaleOrdersRepository(super.dataStore, super.api);

  Future<ApiMarkirovkaCode> findCodeParent(String code) async {
    return await sendSafeRequest<ApiMarkirovkaCode>(() async =>
      await api.saleOrdersFindCodeParent(code: code)
    );
  }

  Future<ApiInfoScan> infoScan(String code, ApiMarkirovkaOrganization markirovkaOrganization) async {
    return await sendSafeRequest<ApiInfoScan>(
      () async => await api.saleOrdersInfoScan(code: code, markirovkaOrganizationId: markirovkaOrganization.id)
    );
  }

  Future<ApiSaleOrder> findSaleOrder(String ndoc) async {
    return await sendSafeRequest<ApiSaleOrder>(() async =>
      await api.saleOrdersIndex(ndoc: ndoc)
    );
  }

  Future<List<ApiSaleOrderStorageLineCode>> findSaleOrderStorageCodes(ApiSaleOrder saleOrder) async {
    return await sendSafeRequest<List<ApiSaleOrderStorageLineCode>>(() async =>
      (await api.saleOrderStorageCodesIndex(saleOrderId: saleOrder.id)).codes
    );
  }

  Future<List<ApiSaleOrderStorageLineCode>> scan(ApiSaleOrder saleOrder, String code, String? groupCode) async {
    return await sendSafeRequest<List<ApiSaleOrderStorageLineCode>>(() async =>
      (await api.saleOrderStorageCodesScan(code: code, groupCode: groupCode, saleOrderId: saleOrder.id)).codes
    );
  }

  Future<List<ApiSaleOrderStorageLineCode>> deleteScan(ApiSaleOrder saleOrder, ApiSaleOrderLine saleOrderLine) async {
    return await sendSafeRequest<List<ApiSaleOrderStorageLineCode>>(() async =>
      (await api.saleOrderStorageCodesDeleteScan(saleOrderSubid: saleOrderLine.subid, saleOrderId: saleOrder.id)).codes
    );
  }

  Future<ApiSaleOrder> completeScan(ApiSaleOrder saleOrder) async {
    return await sendSafeRequest<ApiSaleOrder>(() async =>
      (await api.saleOrdersStorageCodesCompleteScan(saleOrderId: saleOrder.id))
    );
  }

  Future<List<ApiSaleOrderReturnStorageLineCode>> findSaleOrderReturnStorageCodes(ApiSaleOrder saleOrder) async {
    return await sendSafeRequest<List<ApiSaleOrderReturnStorageLineCode>>(() async =>
      (await api.saleOrderReturnStorageCodesIndex(saleOrderId: saleOrder.id)).codes
    );
  }

  Future<List<ApiSaleOrderReturnStorageLineCode>> returnScan(ApiSaleOrder saleOrder, String code) async {
    return await sendSafeRequest<List<ApiSaleOrderReturnStorageLineCode>>(() async =>
      (await api.saleOrderReturnStorageCodesScan(code: code, saleOrderId: saleOrder.id)).codes
    );
  }

  Future<List<ApiSaleOrderReturnStorageLineCode>> deleteReturnScan(
    ApiSaleOrder saleOrder,
    ApiSaleOrderLine saleOrderLine
  ) async {
    return await sendSafeRequest<List<ApiSaleOrderReturnStorageLineCode>>(() async =>
      (await api.saleOrderReturnStorageCodesDeleteScan(saleOrderSubid: saleOrderLine.subid, saleOrderId: saleOrder.id)).codes
    );
  }

  Future<ApiSaleOrder> completeReturnScan(ApiSaleOrder saleOrder) async {
    return await sendSafeRequest<ApiSaleOrder>(() async =>
      (await api.saleOrdersReturnStorageCodesCompleteScan(saleOrderId: saleOrder.id))
    );
  }

  Future<List<ApiSaleOrderDocument>> findSaleOrderDocuments(ApiSaleOrder saleOrder) async {
    return await sendSafeRequest<List<ApiSaleOrderDocument>>(() async =>
      (await api.saleOrderDocumentsIndex(saleOrderId: saleOrder.id)).documents
    );
  }

  Future<void> printDocuments(
    ApiSaleOrder saleOrder,
    int printerId
  ) async {
    return await sendSafeRequest<void>(() async =>
      await api.saleOrdersDocumentsPrintAll(saleOrderId: saleOrder.id, printerId: printerId)
    );
  }
}
