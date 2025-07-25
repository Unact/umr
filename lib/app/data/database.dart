import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';

import '/app/constants/strings.dart';

part 'schema.dart';
part 'database.g.dart';
part 'sale_orders_dao.dart';
part 'users_dao.dart';

@DriftDatabase(
  tables: [
    Users,
    SaleOrderLineCodes
  ],
  daos: [
    UsersDao,
    SaleOrdersDao
  ]
)
class AppDataStore extends _$AppDataStore {
  AppDataStore({
    required bool logStatements
  }) : super(_openConnection(logStatements));

  Future<void> clearData() async {
    await transaction(() async {
      await _clearData();
      await _populateData();
    });
  }

  Future<void> _clearData() async {
    await batch((batch) {
      for (var table in allTables) {
        batch.deleteWhere(table, (row) => const Constant(true));
      }
    });
  }

  Future<void> _populateData() async {
    await batch((batch) {
      batch.insert(users, const User(
        id: UsersDao.kGuestId,
        username: UsersDao.kGuestUsername,
        email: '',
        version: '0.0.0'
      ));
    });
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      for (final entity in allSchemaEntities.reversed) {
        await m.drop(entity);
      }

      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');

      if (details.hadUpgrade || details.wasCreated) await _populateData();
    },
  );
}

LazyDatabase _openConnection(bool logStatements) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, '${Strings.appName}.sqlite'));

    return NativeDatabase.createInBackground(file, logStatements: logStatements, cachePreparedStatements: true);
  });
}

extension UserX on User {
  Future<bool> get newVersionAvailable async {
    final currentVersion = (await PackageInfo.fromPlatform()).version;

    return Version.parse(version) > Version.parse(currentVersion);
  }
}
