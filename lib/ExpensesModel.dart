import 'package:expenses_log/ExpenseDB.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpensesModel extends Model {
  List<Expense> _items = [
    Expense(1, DateTime.now(), "Car", 1000),
    Expense(2, DateTime.now(), "Food", 645),
    Expense(3, DateTime.now(), "Stuff", 788),
  ];
  ExpenseDB _database;

  int get recordsCount => _items.length;

  ExpensesModel() {
    _database = ExpenseDB();
    load();
  }

  void load() {
    Future<List<Expense>> future= _database.getAllExpenses();
    future.then((list) {
      _items = list;
      notifyListeners();
    });
  }

  String getKey(int index) {
    return _items[index].id.toString();
  } 

  String getText(int index) {
    var e = _items[index];
    return e.name + " for " + e.price.toString() + "\n" + DateFormat('yyyy-MM-dd').format(e.date);
  }

  void removeAt(int index) {
    int id = _items[index].id;
    _items.removeAt(index);
    Future<void> future = _database.removeById(id);
    future.then((_) {
      load();
    });
  }

  void addExpense(String name, double price, DateTime dateTime) {
    Future<void> future = _database.addExpense(name, price, dateTime);
    future.then((_) {
      load();
    });
  }

  double getTotal() {
    return _items.fold(0, (p, c) => p + c.price);
  }
}