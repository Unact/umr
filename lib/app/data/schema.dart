part of 'database.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get version => text()();
}

class SaleOrderLineCodes extends Table {
  IntColumn get id => integer()();
  IntColumn get subid => integer()();
  IntColumn get type => integer()();
  TextColumn get code => text()();
  RealColumn get vol => real()();

  @override
  Set<Column> get primaryKey => {id, subid, type, code};
}
