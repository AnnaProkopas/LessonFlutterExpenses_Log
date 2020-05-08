import 'package:expenses_log/ExpensesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class _MonthExpense extends State<MonthExpense> {
  int _year = DateTime.now().year - 1990;
  List<String> _nameMonths = ["January", "February", "March", "April", "May", "June", "July", "August",
     "September", "October", "November", "December"];
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(title: Text("Expenses in months")),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                // model.getMonthsByYear(_year);
                model.updateListMonths();
                return Container(
                  height: 50.0 , 
                  child: ListView(
                  controller:  ScrollController(initialScrollOffset: 80.0 * (_year - 2)),
                  children: List.generate(1010, (int _index) {
                      return Container(
                        width: 80,
                        child: RaisedButton(
                          // Color.fromRGBO(0, 100, 240, 1),
                          color: (_index == _year) ? Color.fromRGBO(70, 170, 250, 1) : Color.fromRGBO(240, 240, 250, 1),
                          child: Text(
                            (1990 + _index).toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: (_index == _year) ? Color.fromRGBO(255, 255, 255, 1) : Color.fromRGBO(40, 40, 40, 1),
                            ),  
                          ),
                          onPressed: () {
                            _year = _index;
                            model.updateListMonths();
                            // print(model.getYear(2020, 5));
                            // print(_year);
                            // model.getMonthsByYear(_year + 1990);
                            // notifyListeners();
                          },
                      ),)
                      ;
                    }),
                  scrollDirection: Axis.horizontal,
                ),
                );
              }
              return Padding(
                  padding: EdgeInsets.only(top: 15, left: 30, right: 30),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _nameMonths[index - 1],
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      model.getYear(_year + 1990, index - 1),
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: 13,
          )
        ),
      ),
    );
  }
}

class MonthExpense extends StatefulWidget {
  @override
  _MonthExpense createState() => _MonthExpense();
}