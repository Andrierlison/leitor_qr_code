// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:leitor_qr_code/data/datasources/delete_history_datasource.dart';

class DeleteHistoryCacheDataSourceImp implements DeleteHistoryDataSource {
  Future<Database> _initDB() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();

    // Open the database and store the reference.
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'history_database.db'),
      // When the database is first created, create a table to store history.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE history(id INTEGER PRIMARY KEY, name TEXT, isFavorite BOOLEAN, dateInsert TEXT)',
        );
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    return database;
  }

  @override
  Future<bool> call({required int id}) async {
    try {
      // Get a reference to the database.
      final db = await _initDB();

      // Remove the history from the database.
      int result = await db.delete(
        'history',
        // Use a `where` clause to delete a specific history.
        where: 'id = $id',
      );

      return result == 1;
    } catch (error) {
      return false;
    }
  }
}
