import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/umr_api.dart';

class RreturnedActsRepository extends BaseRepository {
  RreturnedActsRepository(super.dataStore, super.api);

  Future<ApiRreturnedActsDictionaries> dictionaries() async {
    return await sendSafeRequest<ApiRreturnedActsDictionaries>(() async =>
      (await api.dictionariesRreturnedActs())
    );
  }

  Future<ApiRreturnedAct> findRreturnedAct(String ndoc) async {
    return await sendSafeRequest<ApiRreturnedAct>(() async =>
      (await api.rreturnedActsIndex(ndoc: ndoc))
    );
  }

  Future<ApiRreturnedAct> scanLine(
    ApiRreturnedAct rreturnedAct,
    String code,
    ApiSeller seller,
    ApiStorage storage
  ) async {
    return await sendSafeRequest<ApiRreturnedAct>(() async =>
      (await api.rreturnedActLinesScan(
        code: code,
        rreturnedActId: rreturnedAct.id,
        sellerId: seller.id,
        storageId: storage.id
      ))
    );
  }

  Future<ApiRreturnedAct> deleteLineScan(ApiRreturnedAct rreturnedAct, ApiRreturnedActLine rreturnedActLine) async {
    return await sendSafeRequest<ApiRreturnedAct>(() async =>
      (await api.rreturnedActLinesDeleteScan(rreturnedActId: rreturnedAct.id, code: rreturnedActLine.code))
    );
  }

  Future<ApiRreturnedAct> completeScan(ApiRreturnedAct rreturnedAct) async {
    return await sendSafeRequest<ApiRreturnedAct>(() async =>
      (await api.rreturnedActLinesCompleteScan(rreturnedActId: rreturnedAct.id))
    );
  }
}
