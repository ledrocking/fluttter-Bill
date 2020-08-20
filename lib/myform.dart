import 'package:bill_reminder/bill_list.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/database/bill_data_class.dart';
import 'package:intl/intl.dart';
import 'package:bill_reminder/category/cat_db_helper.dart';

import 'category/cat_db_helper.dart';
import 'category/category_class.dart';
import 'category/getCategoryList.dart';

const darkBlueColor = Color(0xff486579);

class MyForm extends StatefulWidget {
  MyForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  GetCategoryList _getCategoryList = GetCategoryList();

  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];

  Bill _bill = Bill();
  List<Bill> _bills = [];
  DatabaseHelper _dbHelper;
  CatDBHelper _catDBHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlAmount = TextEditingController();
  final _ctrlCat = TextEditingController();
  final _ctrlMyCat = TextEditingController();
  final _ctrlPayAmount = TextEditingController();
  final _ctrlDue = TextEditingController();

//  List<String> _myCats = [];
  var _myCats = [
    'Util',
    'Education',
    'Transport',
  ];
  var _currentItemSelected = '';
/*
  void getCat() async{
    final catList = await _getCategoryList.getList();
    setState(() {
      _myCats = catList;
    });
    _myCats.forEach((element) {
      int i = 1;
      debugPrint('Cat $i is: $element');
      i++;
    });
  }*/

  @override
  initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _catDBHelper = CatDBHelper.instance;
//      getCat();
    });

    _currentItemSelected = _myCats[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors
            .white, // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _form() => Expanded(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),

          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _ctrlName,
                  decoration: InputDecoration(labelText: "Full Name"),
                  onSaved: (val) => setState(() => _bill.name = val),
                  validator: (val) =>
                      (val.length == 0 ? 'This field is required' : null),
                ),
                TextFormField(
                  controller: _ctrlAmount,
                  decoration: InputDecoration(labelText: "Amount"),
                  onSaved: (val) => setState(() => _bill.amount = val),
                  validator: (val) => (val.length < 2
                      ? 'At least 2 characters required'
                      : null),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Category"),
                  value: _currentItemSelected,
                  items: _myCats.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValueSelected) {
                    // Your code to execute, when a menu item is selected from dropdown
                    setState(() {
                      this._currentItemSelected = newValueSelected;
                      _bill.cat = _currentItemSelected;
                    });
                  },
                  onSaved: (String newValueSelected) {
                    // Your code to execute, when a menu item is selected from dropdown
                    setState(() {
                      _bill.cat = _currentItemSelected;
                    });
                  },
                ),
                TextFormField(
                  controller: _ctrlPayAmount,
                  decoration: InputDecoration(labelText: "Pay Amount"),
                  onSaved: (val) => setState(() => _bill.payAmount = val),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text("Pick Date"),
                        color: darkBlueColor,
                        textColor: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () => _selectTime(context),
                        child: Text("Pick Time"),
                        color: darkBlueColor,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _ctrlDue,
                  decoration: InputDecoration(labelText: "Due Date"),
                  onSaved: (val) => setState(() => _bill.due = val),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: () => _onSubmit(),
                    child: Text("Submit"),
                    color: darkBlueColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  _onSubmit() async {
    debugPrint('OnSubmit Func is called');

    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_bill.id == null)
        await _dbHelper.insertBill(_bill);
      else
        await _dbHelper.updateBill(_bill);
//      _resetForm();
      Navigator.of(this.context).push(
        MaterialPageRoute(builder: (context) => BillList(title: "Bill List")),
      );
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlAmount.clear();
      _ctrlCat.clear();
      _ctrlPayAmount.clear();
      _ctrlDue.clear();
      _bill.id = null;
    });
  }

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  var formattedDate = "";
  var formattedTime = "";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2024));
    if (picked != null && picked != _date) {
      print('Date selected : ${_date.toString()}');
      setState(() {
        _date = picked;
      });
//    String formattedDate = DateFormat('dd-MMM-yyy – kk:mm').format(_date);
      formattedDate = DateFormat('dd-MMM-yyy').format(_date);
      debugPrint("$formattedDate");
      _ctrlDue.text = formattedDate;
      return formattedDate;
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 00),
    );
    if (picked != null && picked != _time) {
      print('Time selected : ${_time.toString()}');
      setState(() {
        _time = picked;
      });
      formattedTime = _time.format(context);
      debugPrint("$formattedTime");
      _ctrlDue.text = formattedDate + " " + formattedTime;
    }
  }
}
