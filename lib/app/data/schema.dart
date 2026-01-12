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
  TextColumn get groupCode => text().nullable()();
  RealColumn get vol => real()();
  BoolColumn get isTracking => boolean()();
  DateTimeColumn get localTs => dateTime()();

  @override
  Set<Column> get primaryKey => {id, subid, type, code};
}
