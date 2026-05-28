part of 'database.dart';

@DriftAccessor(tables: [SupplyLineCodes, SupplyLineCodeDetails])
class SuppliesDao extends DatabaseAccessor<AppDataStore> with _$SuppliesDaoMixin {
  SuppliesDao(super.db);

  Stream<List<SupplyLineCode>> watchSupplyLineCodes(int id) {
    return (select(supplyLineCodes)..where((tbl) => tbl.id.equals(id))).watch();
  }

  Stream<List<SupplyLineCodeDetail>> watchSupplyLineCodeDetails(int id) {
    return (select(supplyLineCodeDetails)..where((tbl) => tbl.id.equals(id))).watch();
  }

  Future<void> clearSupplyLineCodes({
    int? id,
    int? subid
  }) async {
    if (id == null) {
      await delete(supplyLineCodes).go();
      return;
    }

    if (subid == null) {
      await (delete(supplyLineCodes)..where((tbl) => tbl.id.equals(id))).go();
      return;
    }

    await (delete(supplyLineCodes)..where((tbl) => tbl.id.equals(id))..where((tbl) => tbl.subid.equals(subid))).go();
  }

  Future<void> clearSupplyLineCodeDetails({
    int? id,
    int? subid
  }) async {
    if (id == null) {
      await delete(supplyLineCodeDetails).go();
      return;
    }

    if (subid == null) {
      await (delete(supplyLineCodeDetails)..where((tbl) => tbl.id.equals(id))).go();
      return;
    }

    await (delete(supplyLineCodeDetails)..where((tbl) => tbl.id.equals(id))..where((tbl) => tbl.subid.equals(subid))).go();
  }

  Future<void> addSupplyLineCodes(List<SupplyLineCodesCompanion> newLineCodes) async {
    await batch((batch) {
      batch.insertAll(supplyLineCodes, newLineCodes, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> addSupplyLineCodeDetails(List<SupplyLineCodeDetailsCompanion> newLineCodeDetails) async {
    await batch((batch) {
      batch.insertAll(supplyLineCodeDetails, newLineCodeDetails, mode: InsertMode.insertOrIgnore);
    });
  }
}
