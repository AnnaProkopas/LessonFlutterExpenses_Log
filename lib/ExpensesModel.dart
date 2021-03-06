import 'package:expenses_log/ExpenseDB.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpensesModel extends Model {
  List<Expense> _items = [];
  ExpenseDB _database;
  int get recordsCount => _items.length;
  Map<int, List<double>> _years = new Map();

  ExpensesModel() {
    _database = ExpenseDB();
    load();
  }

  void load() {
    Future<List<Expense>> future= _database.getAllExpenses();
    future.then((list) {
      _items = list;
      updateListMonths();
      notifyListeners();
    });
  }

  void updateListMonths(){
    if (_years.isEmpty) {
      _years = new Map();
      for (var ex in _items) {
        if (!_years.containsKey(ex.date.year)) {
          _years[ex.date.year] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
        }
        _years[ex.date.year][ex.date.month - 1] += ex.price;
      }
    }
    notifyListeners();
  }

  String getYear(int num_year, int num_month) {
    if (_years.containsKey(num_year)) {
      return _years[num_year][num_month].toString();
    }
    return "0.0";
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
    _years[_items[index].date.year][_items[index].date.month - 1] -= _items[index].price;
    _items.removeAt(index);
    Future<void> future = _database.removeById(id);
    future.then((_) {
      load();
    });
  }

  void addExpense(String name, double price, DateTime dateTime) {
    Future<void> future = _database.addExpense(name, price, dateTime);
    if (!_years.containsKey(dateTime.year)) {
      _years[dateTime.year] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    }
    _years[dateTime.year][dateTime.month - 1] += price;
    future.then((_) {
      load();
    });
  }

  double getTotal() {
    return _items.fold(0, (p, c) => p + c.price);
  }

  Expense getObject(int ind) {
    return _items[ind];
  }

  void updateExpense(int ind, String name, double price, DateTime dateTime) {
    Future<void> future = _database.updateById(_items[ind].id, name, price, dateTime);
    _items[ind] = Expense(_items[ind].id, dateTime, name, price);
    future.then((_) {
      load();
    });
  }
}