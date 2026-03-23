import 'package:drift/drift.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class SuppliesRepository extends BaseRepository {
  SuppliesRepository(super.dataStore, super.api);

  Future<ApiSupply> findSupply(int id) async {
    try {
      return await api.suppliesIndex(id: id);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<ApiSupplyMarkirovkaCode> scan(ApiSupply supply, String code) async {
    try {
      return await api.suppliesScan(code: code, supplyId: supply.id);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<ApiSupply> completeScan(
    ApiSupply supply,
    List<SupplyLineCode> lineCodes
  ) async {
    final codes = lineCodes.map((e) => {
      'subid': e.subid,
      'code': e.code,
      'vol': e.vol,
      'localTs': e.localTs.toIso8601String()
    }).toList();

    try {
      return await api.suppliesCompleteScan(
        supplyId: supply.id,
        codes: codes
      );
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Stream<List<SupplyLineCode>> watchSupplyLineCodes(int id) {
    return dataStore.suppliesDao.watchSupplyLineCodes(id);
  }

  Stream<List<SupplyLineCodeDetail>> watchSupplyLineCodeDetails(int id) {
    return dataStore.suppliesDao.watchSupplyLineCodeDetails(id);
  }

  Future<void> addSupplyLineCode({
    required int id,
    required int subid,
    required String code,
    required int vol,
  }) {
    return dataStore.suppliesDao.addSupplyLineCode(
      SupplyLineCodesCompanion.insert(
        id: id,
        subid: subid,
        code: code,
        vol: vol.toDouble(),
        localTs: DateTime.now()
      )
    );
  }

  Future<void> clearSupplyLineCodes({ApiSupply? supply, ApiSupplyLine? line}) async {
    if (supply == null) {
      await dataStore.suppliesDao.clearSupplyLineCodes();
      return;
    }

    if (line != null) {
      await dataStore.suppliesDao.clearSupplyLineCodes(id: supply.id, subid: line.subid);
      return;
    }

    await dataStore.suppliesDao.clearSupplyLineCodes(id: supply.id);
  }
  Future<void> addSupplyLineCodeDetail({
    required int id,
    required int subid,
    required String cis,
    required String? parent,
    required String initiator,
  }) {
    return dataStore.suppliesDao.addSupplyLineCodeDetail(
      SupplyLineCodeDetailsCompanion.insert(
        id: id,
        subid: subid,
        cis: cis,
        parent: Value(parent),
        initiator: initiator
      )
    );
  }

  Future<void> clearSupplyLineCodeDetails({ApiSupply? supply, ApiSupplyLine? line}) async {
    if (supply == null) {
      await dataStore.suppliesDao.clearSupplyLineCodeDetails();
      return;
    }

    if (line != null) {
      await dataStore.suppliesDao.clearSupplyLineCodeDetails(id: supply.id, subid: line.subid);
      return;
    }

    await dataStore.suppliesDao.clearSupplyLineCodeDetails(id: supply.id);
  }
}
