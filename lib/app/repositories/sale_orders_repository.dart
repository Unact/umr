import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class SaleOrdersRepository extends BaseRepository {
  SaleOrdersRepository(super.dataStore, super.api);

  Future<ApiSaleOrder> findSaleOrder(String ndoc) async {
    try {
      return await api.saleOrdersIndex(ndoc: ndoc);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<ApiMarkirovkaCode> scan(String code) async {
    try {
      return await api.scan(code: code);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> completeScan(ApiSaleOrder saleOrder, SaleOrderScanType type, List<SaleOrderLineCode> lineCodes) async {
    try {
      await api.saleOrdersCompleteScan(
        saleOrderId: saleOrder.id,
        type: type.index,
        codes: lineCodes.map((e) => {'subid': e.subid, 'code': e.code}).toList()
      );
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Stream<List<SaleOrderLineCode>> watchSaleOrderLineCodes(int id) {
    return dataStore.saleOrdersDao.watchSaleOrderLineCodes(id);
  }

  Future<void> addSaleOrderLineCode({
    required int id,
    required int subid,
    required SaleOrderScanType type,
    required String code,
    required int vol
  }) {
    return dataStore.saleOrdersDao.addSaleOrderLineCode(
      SaleOrderLineCodesCompanion.insert(
        id: id,
        subid: subid,
        type: type.index,
        code: code,
        vol: vol.toDouble()
      )
    );
  }

  Future<void> clearSaleOrderLineCodes({ApiSaleOrder? saleOrder, ApiSaleOrderLine? line}) async {
    if (saleOrder == null) {
      await dataStore.saleOrdersDao.clearSaleOrderLineCodes();
      return;
    }

    if (line != null) {
      await dataStore.saleOrdersDao.clearSaleOrderLineCodes(id: saleOrder.id, subid: line.subid);
      return;
    }

    await dataStore.saleOrdersDao.clearSaleOrderLineCodes(id: saleOrder.id);
  }
}
