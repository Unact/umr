import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';

import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';
class AppRepository extends BaseRepository {
  static const int _kMaxPageAppErrors = 100;
  final List<PageMessagesInfo> _pageMessages = [];

  AppRepository(super.dataStore, super.api);

  void addPageMessagesInfo({ required String message, required DateTime date }) {
    _pageMessages.add(PageMessagesInfo(message, date));

    if (_pageMessages.length > _kMaxPageAppErrors) _pageMessages.removeAt(0);
  }

  void clearPageMessagesInfo() {
    _pageMessages.clear();
  }

  List<PageMessagesInfo> getPageMessagesInfo() {
    return _pageMessages;
  }

  Future<void> clearData() async {
    await dataStore.clearData();
  }

  Future<List<ApiMarkirovkaOrganization>> loadMarkirovkaOrganizations() async {
    try {
      return await api.markirovkaOrganizations();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<T> transaction<T>(Future<T> Function() operation) {
    return dataStore.transaction(operation);
  }
}
