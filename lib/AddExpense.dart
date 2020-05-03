import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _AddExpenseState extends State<AddExpense> {
  double _price;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
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
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
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
  @override 
  State<StatefulWidget> createState() => _AddExpenseState();
}