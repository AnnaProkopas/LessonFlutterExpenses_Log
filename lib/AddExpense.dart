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
        padding: const EdgeInsets.all(32.0),
        child: Form( 
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autovalidate: true,
              initialValue: "0",
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
              onSaved: (value) {
                _name = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(DateFormat('yyyy-MM-dd').format(_dateTime)),
            ),
            RaisedButton(
              child: Text("Choose day"),
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
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                   _model.addExpense(_name, _price, _dateTime);
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            )
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