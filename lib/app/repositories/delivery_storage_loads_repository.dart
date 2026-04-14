import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class DeliveryStorageLoadsRepository extends BaseRepository {
  DeliveryStorageLoadsRepository(super.dataStore, super.api);

  Future<ApiDeliveryStorageLoad> findDeliveryStorageLoad(String ndoc) async {
    try {
      return await api.deliveryStorageLoadsIndex(ndoc: ndoc);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<ApiDeliveryStorageLoad> startLoadOrder(ApiDeliveryStorageLoadSaleOrder deliveryStorageLoadSaleOrder) async {
    try {
      return await api.deliveryStorageLoadsStartLoadOrder(
        deliveryStorageLoadSaleOrderId: deliveryStorageLoadSaleOrder.id
      );
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<ApiDeliveryStorageLoad> completeDeliveryLoad(ApiDeliveryStorageLoad deliveryStorageLoad) async {
    try {
      return await api.deliveryStorageLoadsCompleteDeliveryLoad(
        deliveryStorageLoadId: deliveryStorageLoad.id
      );
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }
}
