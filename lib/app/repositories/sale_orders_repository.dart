import 'package:drift/drift.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class SaleOrdersRepository extends BaseRepository {
  SaleOrdersRepository(super.dataStore, super.api);

  Future<ApiInfoScan> infoScan(String code, ApiMarkirovkaOrganization markirovkaOrganization) async {
    try {
      return await api.saleOrdersInfoScan(code: code, markirovkaOrganizationId: markirovkaOrganization.id);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

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

  Future<ApiMarkirovkaCode> scan(ApiSaleOrder saleOrder, SaleOrderScanType type, String code) async {
    try {
      return await api.scan(code: code, type: type.index, saleOrderId: saleOrder.id);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> completeScan(ApiSaleOrder saleOrder, SaleOrderScanType type, List<SaleOrderLineCode> lineCodes) async {
    final codes = lineCodes.map((e) => {
      'subid': e.subid,
      'code': e.code,
      'groupCode': e.groupCode,
      'vol': e.vol,
      'isTracking': e.isTracking
    }).toList();

    try {
      await api.saleOrdersCompleteScan(
        saleOrderId: saleOrder.id,
        type: type.index,
        codes: codes
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
    required String? groupCode,
    required int vol,
    required bool isTracking
  }) {
    return dataStore.saleOrdersDao.addSaleOrderLineCode(
      SaleOrderLineCodesCompanion.insert(
        id: id,
        subid: subid,
        type: type.index,
        code: code,
        groupCode: Value(groupCode),
        vol: vol.toDouble(),
        isTracking: isTracking
      )
    );
  }

  Future<void> clearSaleOrderLineCodes({ApiSaleOrder? saleOrder, ApiSaleOrderLine? line, String? groupCode}) async {
    if (groupCode != null) {
      await dataStore.saleOrdersDao.clearSaleOrderLineCodes(groupCode: groupCode);
      return;
    }

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
