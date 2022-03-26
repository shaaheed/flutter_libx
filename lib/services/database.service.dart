// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseService {
//   Future<Database> getDatabase() async {
//     final Future<Database> database = openDatabase(
//       join(await getDatabasesPath(), 'money_bag.db'),
//       onCreate: (db, version) async {
//         // currency
//         await db.execute('''
//           CREATE TABLE "currency" (
//             "id"	TEXT NOT NULL UNIQUE,
//             "name"	TEXT NOT NULL,
//             "code"	TEXT NOT NULL,
//             "symbol"	TEXT NOT NULL,
//             "image"	TEXT
//           );
//         ''');

//         // insert currencies from json file
//         String jsonString =
//             await rootBundle.loadString('assets/json/currencies.json');
//         List<dynamic> currencies = json.decode(jsonString);
//         int index = 0;
//         for (var i = 0; i < currencies.length; i++) {
//           String name = currencies[i]['name'];
//           String code = currencies[i]['code'];
//           String symbol = currencies[i]['symbol'];
//           String sql =
//               '''INSERT INTO "currency" ("id", "name", "code", "symbol") VALUES ('$index', '$name', '$code', '$symbol');''';
//           await db.execute(sql);
//           index++;
//         }

//         // await db.execute('''
//         //   INSERT INTO "currency"
//         //   ("id", "name", "symbol")
//         //   VALUES ('1', 'Bangladeshi Taka', '৳');
//         // ''');

//         // wallet
//         await db.execute('''
//           CREATE TABLE "wallet" (
//             "id"	TEXT NOT NULL UNIQUE,
//             "name"	TEXT NOT NULL,
//             "currency"	TEXT NOT NULL,
//             "balance"	REAL DEFAULT 0,
//             "image" TEXT,
//             "total_transaction"	INTEGER DEFAULT 0,
//             "total_income"	REAL DEFAULT 0,
//             "total_expense"	REAL DEFAULT 0,
//             "average_income"	REAL DEFAULT 0,
//             "average_expense"	REAL DEFAULT 0,
//             "first_transaction"	TEXT,
//             "last_transaction"	TEXT,
//             FOREIGN KEY("currency") REFERENCES "currency"("id"),
//             FOREIGN KEY("first_transaction") REFERENCES "transaction"("id"),
//             FOREIGN KEY("last_transaction") REFERENCES "transaction"("id")
//           );
//         ''');

//         await db.execute('''
//           INSERT INTO "wallet"
//           ("id", "name", "currency")
//           VALUES ('1', 'Cash', '0');
//         ''');

//         // category_type
//         await db.execute('''
//           CREATE TABLE "category_type" (
//             "id"	TEXT NOT NULL UNIQUE,
//             "name"	TEXT NOT NULL
//           );
//         ''');

//         await db.execute('''
//           INSERT INTO "category_type"
//           ("id", "name")
//           VALUES ('1', 'Income'),
//           ('2', 'Expense'),
//           ('3', 'Debt & Loan');
//         ''');

//         // category
//         await db.execute('''
//           CREATE TABLE "category" (
//             "id"	TEXT NOT NULL UNIQUE,
//             "name"	TEXT NOT NULL,
//             "image"	TEXT,
//             "type"	TEXT NOT NULL,
//             "parent"	TEXT,
//             "wallet"	TEXT,
//             "total_amount"	REAL DEFAULT 0,
//             "total_transaction"	INTEGER DEFAULT 0,
//             "average_amount"	REAL DEFAULT 0,
//             "first_transaction"	TEXT,
//             "last_transaction"	TEXT,
//             FOREIGN KEY("type") REFERENCES "category_type"("id"),
//             FOREIGN KEY("wallet") REFERENCES "wallet"("id"),
//             FOREIGN KEY("first_transaction") REFERENCES "transaction"("id"),
//             FOREIGN KEY("last_transaction") REFERENCES "transaction"("id")
//           );
//         ''');

//         // budget
//         await db.execute('''
//           CREATE TABLE "budget" (
//             "id"	TEXT NOT NULL UNIQUE,
//             "amount"	REAL NOT NULL DEFAULT 0,
//             "spent"	REAL NOT NULL DEFAULT 0,
//             "note"	TEXT,
//             "wallet"  TEXT,
//             "start_date" REAL NOT NULL,
//             "end_date"  REAL NOT NULL,
//             "category"  TEXT NOT NULL,
//             "repeat"	INTEGER NOT NULL DEFAULT 0,
//             "completed"	INTEGER NOT NULL DEFAULT 0,
//             "notification"	INTEGER NOT NULL DEFAULT 0,
//             FOREIGN KEY("wallet") REFERENCES "wallet"("id"),
//             FOREIGN KEY("category") REFERENCES "category"("id")
//           );
//         ''');

//         // event
//         await db.execute('''
//           CREATE TABLE "event" (
//             "id"	TEXT NOT NULL UNIQUE,
//             "spent"	REAL DEFAULT 0,
//             "note"	TEXT,
//             "wallet"  TEXT,
//             "start_date" REAL NOT NULL,
//             "end_date"  REAL NOT NULL,
//             "actual_end_date"  REAL NOT NULL,
//             "completed"	INTEGER NOT NULL DEFAULT 0,
//             FOREIGN KEY("wallet") REFERENCES "wallet"("id")
//           );
//         ''');

//         // transaction
//         await db.execute('''
//           CREATE TABLE "transaction" (
//             "id"	TEXT NOT NULL UNIQUE,
//             "amount"	REAL NOT NULL DEFAULT 0,
//             "note"	TEXT,
//             "wallet"	TEXT,
//             "budget"	TEXT,
//             "event"	TEXT,
//             "category"	TEXT NOT NULL,
//             "date"	REAL NOT NULL,
//             "quantity"	INTEGER,
//             "rate"	INTEGER,
//             FOREIGN KEY("wallet") REFERENCES "wallet"("id"),
//             FOREIGN KEY("budget") REFERENCES "budget"("id"),
//             FOREIGN KEY("event") REFERENCES "event"("id"),
//             FOREIGN KEY("category") REFERENCES "category"("id")
//           );
//         ''');

//         // key_value
//         await db.execute('''
//           CREATE TABLE "key_value" (
//             "key" TEXT,
//             "value" TEXT
//           );
//         ''');
//       },
//       onUpgrade: (db, oldVersion, newVersion) async {
//         if (oldVersion < newVersion) {
//           // await db.execute('''
//           //   CREATE TABLE "key_value" (
//           //     "key" TEXT,
//           //     "value" TEXT
//           //   );
//           // ''');
//         }
//       },
//       version: 1,
//     );
//     return database;
//   }

//   execute(String sql, [List<dynamic> arguments]) async {
//     final db = await getDatabase();
//     if (db != null) {
//       await enableForeignKey(db);
//       return db.execute(sql, arguments);
//     }
//   }

//   Future<int> rawInsert(String sql, [List<dynamic> arguments]) async {
//     final db = await getDatabase();
//     if (db != null) {
//       await enableForeignKey(db);
//       return db.rawInsert(sql, arguments);
//     }
//     return Future.value(0);
//   }

//   Future<int> insert(InsertSql command) async {
//     final db = await getDatabase();
//     if (db != null) {
//       await enableForeignKey(db);
//       return db.rawInsert(command.sql(), command.arguments());
//     }
//     return Future.value(0);
//   }

//   Future<List<Map<String, dynamic>>> rawQuery(
//     String sql, [
//     List<dynamic> arguments,
//   ]) async {
//     final db = await getDatabase();
//     // workable code
//     // String jsonString = await rootBundle.loadString('assets/sql/sql.json');
//     // Map<String, dynamic> jsonMap = json.decode(jsonString);
//     if (db != null) {
//       return db.rawQuery(sql, arguments);
//     }
//     return null;
//   }

//   Future<String> get(
//     String sql,
//     String valueKey, [
//     List<dynamic> arguments,
//   ]) async {
//     var result = await rawQuery(sql, arguments);
//     if (result != null && result.length > 0) {
//       return result[0][valueKey];
//     }
//     return null;
//   }

//   Future<int> rawUpdate(String sql, [List<dynamic> arguments]) async {
//     final db = await getDatabase();
//     if (db != null) {
//       await enableForeignKey(db);
//       return db.rawUpdate(sql, arguments);
//     }
//     return Future.value(0);
//   }

//   Future<int> rawDelete(String sql, [List<dynamic> arguments]) async {
//     final db = await getDatabase();
//     if (db != null) {
//       await enableForeignKey(db);
//       return db.rawDelete(sql, arguments);
//     }
//     return Future.value(0);
//   }

//   static Future<void> enableForeignKey(Database db) {
//     String sql = "PRAGMA foreign_keys = ON";
//     return db.execute(sql);
//   }
// }
