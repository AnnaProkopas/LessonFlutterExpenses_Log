import 'package:expenses_log/AddExpense.dart';
import 'package:expenses_log/Expense.dart';
import 'package:expenses_log/ExpensesModel.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
            itemBuilder: (context, index){
              if (index == 0) {
                return ListTile(
                  title: Text("Total expenses: 2001"),
                );
              } else {
                index -= 1;
                return Dismissible(
                  key: Key(model.getKey(index)),
                  onDismissed: (direction) {
                    model.removeAt(index);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Deleted record $index", textDirection: TextDirection.ltr,),)
                    );
                  },
                  child: ListTile(
                    title: Text(model.getText(index)),
                    leading: Icon(Icons.attach_money),
                    trailing: Icon(Icons.delete),
                  ),
                );
              }
            }, 
            separatorBuilder: (context, index) => Divider(color: Color(0xffaa0099),), 
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
                    return AddExpense();
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
