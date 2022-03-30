import 'dart:async';
import 'package:libx/libx.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseService {
  /// Default databases location.
  Future<String> get path => getDatabasesPath();

  /// Default databases name.
  String get name;

  /// [onCreate] is called if the database did not exist prior to calling
  /// [openDatabase]. You can use the opportunity to create the required tables
  /// in the database according to your schema
  FutureOr<void> onCreate(Database db, int version);

  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion);

  /// [version] (optional) specifies the schema version of the database being opened.
  int? version;

  bool get enableForeignKey => true;

  Future<Database> getDatabase() async {
    final Future<Database> database = openDatabase(
      join(await path, name),
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      version: version,
    );
    return database;
  }

  execute(String sql, [List<dynamic>? arguments]) async {
    final db = await getDatabase();
    await _enableForeignKey(db);
    return db.execute(sql, arguments);
  }

  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async {
    final db = await getDatabase();
    await _enableForeignKey(db);
    return db.rawInsert(sql, arguments);
  }

  Future<int> insert(InsertSql command) async {
    final db = await getDatabase();
    await _enableForeignKey(db);
    return db.rawInsert(command.sql(), command.arguments());
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await getDatabase();
    // workable code
    // String jsonString = await rootBundle.loadString('assets/sql/sql.json');
    // Map<String, dynamic> jsonMap = json.decode(jsonString);
    return db.rawQuery(sql, arguments);
  }

  Future<String?> get(
    String sql,
    String valueKey, [
    List<dynamic>? arguments,
  ]) async {
    var result = await rawQuery(sql, arguments);
    if (result.isNotEmpty) {
      return result[0][valueKey];
    }
    return null;
  }

  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    final db = await getDatabase();
    await _enableForeignKey(db);
    return db.rawUpdate(sql, arguments);
  }

  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    final db = await getDatabase();
    await _enableForeignKey(db);
    return db.rawDelete(sql, arguments);
  }

  static Future<void> _enableForeignKey(Database db) {
    String sql = "PRAGMA foreign_keys = ON";
    return db.execute(sql);
  }
}
