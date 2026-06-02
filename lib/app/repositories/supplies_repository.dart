import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
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

  Future<List<ApiSupplyStorageLineCode>> findSupplyStorageCodes(ApiSupply supplyId) async {
    return await sendSafeRequest<List<ApiSupplyStorageLineCode>>(() async =>
      (await api.suppliesStorageCodesIndex(supplyId: supplyId.id)).codes
    );
  }

  Future<List<ApiSupplyStorageLineCode>> scan(ApiSupply supply, String code, bool onlyPiece) async {
    return await sendSafeRequest<List<ApiSupplyStorageLineCode>>(() async =>
      (await api.suppliesStorageCodesScan(code: code, onlyPiece: onlyPiece, supplyId: supply.id)).codes
    );
  }

  Future<List<ApiSupplyStorageLineCode>> deleteScan(ApiSupply supply, ApiSupplyLine supplyLine) async {
    return await sendSafeRequest<List<ApiSupplyStorageLineCode>>(() async =>
      (await api.suppliesStorageCodesDeleteScan(supplySubid: supplyLine.subid, supplyId: supply.id)).codes
    );
  }

  Future<ApiSupply> completeScan(ApiSupply supply) async {
    return await sendSafeRequest<ApiSupply>(() async =>
      (await api.suppliesStorageCodesCompleteScan(supplyId: supply.id))
    );
  }
}
