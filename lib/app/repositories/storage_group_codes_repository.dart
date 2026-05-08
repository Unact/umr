import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class StorageGroupCodesRepository extends BaseRepository {
  StorageGroupCodesRepository(super.dataStore, super.api);

  Future<ApiStorageGroupCode> findStorageGroupCode(
    String groupCode,
    ApiMarkirovkaOrganization markirovkaOrganization
  ) async {
    return await sendSafeRequest(() async =>
      await api.storageGroupCodesIndex(groupCode: groupCode, markirovkaOrganizationId: markirovkaOrganization.id)
    );
  }

  Future<ApiStorageGroupCode> scan(ApiStorageGroupCode storageGroupCode, String code) async {
    return await sendSafeRequest(
      () async => await api.storageGroupCodesScan(storageGroupCodeId: storageGroupCode.id, code: code)
    );
  }

  Future<ApiStorageGroupCode> deleteScan(ApiStorageGroupCode storageGroupCode, String code) async {
    return await sendSafeRequest(
      () async => await api.storageGroupCodesDeleteScan(storageGroupCodeId: storageGroupCode.id, code: code)
    );
  }

  Future<ApiStorageGroupCode> completeScan(ApiStorageGroupCode storageGroupCode) async {
    return await sendSafeRequest(
      () async => await api.storageGroupCodesCompleteScan(storageGroupCodeId: storageGroupCode.id)
    );
  }

  Future<void> deleteStorageGroupCode(String groupCode) async {
    return await sendSafeRequest(() async => await api.storageGroupCodesDelete(groupCode: groupCode));
  }
}
