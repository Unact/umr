import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class AppRepository extends BaseRepository {
  AppRepository(super.dataStore, super.api);

  Future<ApiCode> scan({ required String code }) async {
    try {
      return await api.scan(code: code);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> clearData() async {
    await dataStore.clearData();
  }
}
