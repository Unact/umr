part of 'database.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get version => text()();
}

class SupplyLineCodes extends Table {
  IntColumn get id => integer()();
  IntColumn get subid => integer()();
  TextColumn get code => text()();
  RealColumn get vol => real()();
  DateTimeColumn get localTs => dateTime()();

  @override
  Set<Column> get primaryKey => {id, subid, code};
}

class SupplyLineCodeDetails extends Table {
  IntColumn get id => integer()();
  IntColumn get subid => integer()();
  TextColumn get cis => text()();
  TextColumn get parent => text().nullable()();
  TextColumn get initiator => text()();

  @override
  Set<Column> get primaryKey => {id, subid, cis};
}
