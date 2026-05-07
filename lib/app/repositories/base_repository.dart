import 'dart:async';

import 'package:u_app_utils/u_app_utils.dart';

import '/app/entities/entities.dart';
import '/app/data/database.dart';
import '/app/constants/strings.dart';

class BaseRepository {
  final AppDataStore dataStore;
  final RenewApi api;

  BaseRepository(this.dataStore, this.api);

  FutureOr<T> sendSafeRequest<T>(FutureOr<T> Function() request) async {
    try {
      return await request.call();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }
}
