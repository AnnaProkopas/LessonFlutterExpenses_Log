import 'package:expenses_log/ExpenseDB.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpensesModel extends Model {
  int _idGenerator = 3;

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
    return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void addExpense(String name, double price) {
    _idGenerator += 1;
    var e = Expense(_idGenerator, DateTime.now(), name, price);
    _items.add(e);
    notifyListeners();
  }
}