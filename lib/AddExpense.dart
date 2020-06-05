import 'package:expenses_log/ExpensesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class _AddExpenseState extends State<AddExpense> {
  double _price;
  String _name;
  ExpensesModel _model;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();

  _AddExpenseState(this._model);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0, right: 32.0, bottom: 32.0, left: 32.0),
        child: Form( 
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autovalidate: true,
              decoration: new InputDecoration.collapsed(
                hintText: "0"
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (double.tryParse(value) != null) {
                  return null;
                } else {
                  return "Enter the valid price";
                }
              },
              onSaved: (value) {
                _price = double.parse(value);
              },
            ),
            TextFormField(
              autovalidate: true,
              decoration: new InputDecoration.collapsed(
                hintText: "food"
              ),
              minLines: 1,
              maxLines: 5,
              validator: (value) {
                if (value.length < 1) {
                  return "Enter discription";
                } else if (value.length > 200) {
                  return "Description too long";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                _name = value;
              },
            ),
            Text(DateFormat('yyyy-MM-dd').format(_dateTime),
              style: TextStyle(
                height: 3.0,
                fontSize: 18
              ),
            ),
            Container(
              width: 200,
              height: 30,
              child: RaisedButton(
                child: Text("Choose another day"),
                onPressed: () {
                  showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: DateTime(1990), 
                    lastDate: DateTime(3000)
                  ).then((date) {
                    setState(() {
                      _dateTime = date;
                    });
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: 100,
                height: 40,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _model.addExpense(_name, _price, _dateTime);
                    Navigator.pop(context);
                  }
                },
                  child: Center(child: Text("Add", style: TextStyle(
                    fontSize: 20, 
                    color: Colors.white
                    ),)
                  )
                ),
              )
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class AddExpense extends StatefulWidget {
  final ExpensesModel _model;

  AddExpense(this._model);

  @override 
  State<StatefulWidget> createState() => _AddExpenseState(_model);
}