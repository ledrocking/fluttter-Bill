import 'package:bill_reminder/category/category_class.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'bill_list.dart';


const darkBlueColor = Color(0xff486579);

class EditForm extends StatefulWidget {
  final String appBarTitle;
  final Bill bill;

  EditForm(this.bill, this.appBarTitle);


  @override
  _EditFormState createState() => _EditFormState(this.bill, this.appBarTitle);
}

class _EditFormState extends State<EditForm> {
//  int _counter = 0;


  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];

  List<String> _myCats = [];
  var _currentItemSelected = '';

  String appBarTitle;
  Bill _bill = Bill();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlCat = TextEditingController();
  final _ctrlStartDate = TextEditingController();
  final _ctrlEndDate = TextEditingController();
  final _ctrlPeriodic = TextEditingController();
  final _ctrlBillIcon = TextEditingController();

  _EditFormState(this._bill, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _bill.cat;
    setState(() {
      _dbHelper = DatabaseHelper.instance;

      _refreshMyCategoryList();
      if (this._bill != null){
        _ctrlName.text = _bill.name;
        _ctrlCat.text = _bill.cat;
        _ctrlStartDate.text = _bill.startDate;
        _ctrlPeriodic.text = _bill.periodic;
        _ctrlEndDate.text = _bill.endDate;
        _ctrlBillIcon.text = _bill.billIcon;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors
            .lightBlue, // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(
            widget.appBarTitle,
            style: TextStyle(color: Colors.white),
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



  _form() => Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 7,
                child: TextFormField(
                  controller: _ctrlStartDate,
                  decoration: InputDecoration(labelText: "Start Date"),
                  onSaved: (val) => setState(() => _bill.startDate = val),
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(this.context),
                  color: darkBlueColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 7,
                child: TextFormField(
                  controller: _ctrlEndDate,
                  decoration: InputDecoration(labelText: "End Date"),
                  onSaved: (val) => setState(() => _bill.endDate = val),
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(this.context),
                  color: darkBlueColor,
                ),
              ),
            ],
          ),


          TextFormField(
            controller: _ctrlPeriodic,
            decoration: InputDecoration(labelText: "Periodic"),
            onSaved: (val) => setState(() => _bill.periodic = val),
            validator: (val) => (val.length < 2
                ? 'At least 2 characters required'
                : null),
          ),

          TextFormField(
            controller: _ctrlBillIcon,
            decoration: InputDecoration(labelText: "Bill Icon"),
            onSaved: (val) => setState(() => _bill.billIcon = val),
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
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => MyCategoryList(title: "Add Category")));
              },
              child: Text("Add Category"),
              color: darkBlueColor,
              textColor: Colors.white,
            ),
          ),
        ],
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
      _ctrlPeriodic.clear();
      _ctrlCat.clear();
      _ctrlEndDate.clear();
      _ctrlStartDate.clear();
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
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2024));
    if (picked != null && picked != _date) {
      print('Date selected : ${_date.toString()}');
      setState(() {
        _date = picked;
      });
//    String formattedDate = DateFormat('dd-MMM-yyy – kk:mm').format(_date);
      formattedDate = DateFormat('dd-MMM-yyy').format(_date);
      debugPrint("$formattedDate");
      _ctrlStartDate.text = formattedDate;
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
      _ctrlStartDate.text = formattedDate + " " + formattedTime;
    }
  }

  List<String> _myCatList = [];

  _refreshMyCategoryList() async {
    List<MyCategory> x = await _dbHelper.fetchMyCategories();
    setState(() {
      _myCategories = x;
    });
    int i = 1;
    _myCategories.forEach((element) {
      debugPrint(element.name);
      _myCatList.add('$i ' + element.name);
      _myCats.add(element.name);
      i++;
    });
    debugPrint('This is from refresh myCats');
    int catNo = 1;

    _myCats.forEach((element) {
      debugPrint('Cat No $catNo: $element');
      catNo++;
    });
    debugPrint('This is from refresh myCatList');
    _myCatList.forEach((element) {
      debugPrint('Cat is: $element');
    });
  }
}
