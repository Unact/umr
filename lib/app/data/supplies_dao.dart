part of 'database.dart';

@DriftAccessor(tables: [SupplyLineCodes])
class SuppliesDao extends DatabaseAccessor<AppDataStore> with _$SuppliesDaoMixin {
  SuppliesDao(super.db);

  Stream<List<SupplyLineCode>> watchSupplyLineCodes(int id) {
    return (select(supplyLineCodes)..where((tbl) => tbl.id.equals(id))).watch();
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

  Future<void> addSupplyLineCode(SupplyLineCodesCompanion newLineCode) async {
    await into(supplyLineCodes).insert(newLineCode, mode: InsertMode.insertOrReplace);
  }
}
