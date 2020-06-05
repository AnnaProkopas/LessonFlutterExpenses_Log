import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'Expense.dart';

class ExpenseDB {
  Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await initialize();
    }
    return _database;
  }

  ExpenseDB() {}

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    return openDatabase(
      documentsDir.path + "/" + "db.db",
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT);");
      },
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT * FROM Expenses ORDER BY date(date) DESC");
    var result = List<Expense>();
    query.forEach((r) => result.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"])));
    return result;
  }

  Future<void> addExpense(String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dateAsString = DateFormat('yyyy-MM-dd 00:00:00').format(dateTime);
    await db.rawInsert("INSERT INTO Expenses (name, date, price) VALUES (\"$name\", \"$dateAsString\", $price);");
  }

  Future<void> removeById(int id) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expenses WHERE id = $id;");
  }

  Future<void> updateById(int id, String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dateAsString = DateFormat('yyyy-MM-dd 00:00:00').format(dateTime);
    await db.rawUpdate("UPDATE Expenses SET name = \"$name\", price = $price, date = \"$dateAsString\" WHERE id = $id;");
  }
}