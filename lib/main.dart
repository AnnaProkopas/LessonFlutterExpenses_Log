import 'package:expenses_log/AddExpense.dart';
import 'package:expenses_log/EditExpense.dart';
import 'package:expenses_log/Expense.dart';
import 'package:expenses_log/ExpensesModel.dart';
import 'package:expenses_log/MonthExpense.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My expenses'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, textDirection: TextDirection.ltr),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.calendar_today), 
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MonthExpense();
                    }
                  ),
                );
              }
            )
          ],
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
            itemBuilder: (context, index){
              if (index == 0) {
                return ListTile(
                  title: Text("Total expenses: " + model.getTotal().toString()),
                );
              } else {
                index -= 1;
                return Dismissible (
                  key: Key(model.getKey(index)),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                            title: Text("Submit delete"),
                            content: Text("Are you shure delete record $index?"),
                            actions: [
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              FlatButton(
                                child: Text("Delete"),
                                onPressed: () {
                                  model.removeAt(index);
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          ),
                      );
                    } if (direction == DismissDirection.endToStart) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditExpense(model, index);
                          }
                        )
                      );
                    }
                  },
                  child: ListTile(
                    title: Text(model.getText(index)),
                    leading: Icon(Icons.edit),
                    trailing: Icon(Icons.delete),
                  ),
                );
              }
            }, 
            separatorBuilder: (context, index) => Divider(color: Color(0xff02a4d3),), 
            itemCount: model.recordsCount + 1,
          ),
        ),
        floatingActionButton: ScopedModelDescendant<ExpensesModel> (
          builder: (context, child, model) => FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddExpense(model);
                  }
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ), 
    );
  }
}
