import '/app/repositories/base_repository.dart';

class AppRepository extends BaseRepository {
  AppRepository(super.dataStore, super.api);

  Future<void> clearData() async {
    await dataStore.clearData();
  }
}
