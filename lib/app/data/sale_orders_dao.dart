part of 'database.dart';

@DriftAccessor(tables: [SaleOrderLineCodes])
class SaleOrdersDao extends DatabaseAccessor<AppDataStore> with _$SaleOrdersDaoMixin {
  SaleOrdersDao(super.db);

  Stream<List<SaleOrderLineCode>> watchSaleOrderLineCodes(int id) {
    return (select(saleOrderLineCodes)..where((tbl) => tbl.id.equals(id))).watch();
  }

  Future<void> clearSaleOrderLineCodes({
    required int id,
    int? subid
  }) async {
    if (subid != null) {
      await (
        delete(saleOrderLineCodes)..where((tbl) => tbl.id.equals(id))..where((tbl) => tbl.subid.equals(subid))
      ).go();
    } else {
      await (delete(saleOrderLineCodes)..where((tbl) => tbl.id.equals(id))).go();
    }
  }

  Future<void> addSaleOrderLineCode(SaleOrderLineCodesCompanion newLineCode) async {
    await into(saleOrderLineCodes).insert(newLineCode, mode: InsertMode.insertOrReplace);
  }
}

enum SaleOrderScanType {
  realization,
  correction
}
