import 'package:flutter/material.dart';

import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:bill_reminder/bill/bill_list.dart';


import 'package:bill_reminder/category/category_list.dart';
import 'package:bill_reminder/category/category_class.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'package:path/path.dart';

import 'dart:io';
import 'package:intl/intl.dart';



const darkBlueColor = Color(0xff486579);

class MyForm extends StatefulWidget {
  MyForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {


  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];

  Bill _bill = Bill();
  List<Bill> _bills = [];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlCat = TextEditingController();
  final _ctrlStartDate = TextEditingController();
  final _ctrlEndDate = TextEditingController();
  final _ctrlPeriodic = TextEditingController();
  final _ctrlBillIcon = TextEditingController();

  final _ctrlMyCat = TextEditingController();




  List<String> _myCats = [];
  var _currentItemSelected = '';

  int i = 1;




  @override
  initState() {
    super.initState();

    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _refreshMyCategoryList();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors
            .lightBlue, // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Container(
        child: ListView(
//          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 7,
                child: DropdownButtonFormField<String>(

                  decoration: InputDecoration(labelText: "Category"),
//            value: _currentItemSelected,
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
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.add_box),
                  tooltip: "Add new",
                  onPressed: () {
                    Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => MyCategoryList(title: "Add Category")));
                  },
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
                  controller: _ctrlStartDate,
                  decoration: InputDecoration(labelText: "Start Date"),
                  onSaved: (val) => setState(() => _bill.startDate = val),
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(this.context, 1),
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
                  onPressed: () => _selectDate(this.context, 2),
                  color: darkBlueColor,
                ),
              ),
            ],
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


  Future<Null> _selectDate(BuildContext context, int source) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2024));
    if (picked != null && picked != _date) {
      print('Date selected : ${_date.toString()}');
      print('source : $source');
      setState(() {
        _date = picked;
      });
//    String formattedDate = DateFormat('dd-MMM-yyy – kk:mm').format(_date);
      formattedDate = DateFormat('dd-MMM-yyy').format(_date);
      debugPrint("$formattedDate");

      if (source == 1) {
        _ctrlStartDate.text = formattedDate;
      }
      else {
        _ctrlEndDate.text = formattedDate;
      }
//      return formattedDate.toString();
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
