import 'dart:ffi';

import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/Transact/transbill_class.dart';
import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';

import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:bill_reminder/bill/bill_list.dart';

import 'package:bill_reminder/category/category_list.dart';
import 'package:bill_reminder/category/category_class.dart';

import 'package:bill_reminder/Transact/transact_class.dart';

import 'package:bill_reminder/database/database_helper.dart';

import 'package:path/path.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../component/NavDrawer.dart';

const darkBlueColor = Color(0xff486579);

class MyForm extends StatefulWidget {
  MyForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {

  Bill _bill = Bill();
  List<Bill> _bills = [];

  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];

  Transact _transact = Transact();


  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlCat = TextEditingController();
  final _ctrlStartDate = TextEditingController();
  final _ctrlAmount = TextEditingController();
  final _ctrlPeriodic = TextEditingController();
  final _ctrlEndDate = TextEditingController();
  final _ctrlBillIcon = TextEditingController();

  final _ctrlMyCat = TextEditingController();



  List<String> _listPeriodic = ["Monthly", "Biweekly", "Weekly", "No Repeat"];
  List<String> _myCats = [];
  var _currentItemSelected = '';
  var _currentPeriodicSelected = '';


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
    return MyHeader(myTitle: "New BIlls", myContent: _form(),);
  }

  _onSubmit() async {

    //Insert data into  Table
    var form = _formKey.currentState;
    int insertedID;

    if (form.validate()) {
      form.save();
      if (_bill.id == null){

        // Insert data into Bill Table and return last inserted rowID
        insertedID = await _dbHelper.insertBill2(_bill);
        debugPrint("Insert ID Captured is : $insertedID"); //
        //OK       await _dbHelper.insertBill2(_bill); // Insert data into Bill Table

        //Insert data into Transact Table
        var _start = DateTime.parse(_bill.startDate);
        var _end = DateTime.parse(_bill.endDate);
        _end = new DateTime(_end.year, _end.month, _end.day + 1);

        var _periodic = "Monthly";
        int _number = 1;

        do {
          _transact.billID = insertedID;
          _transact.dueDate = _start.toString();
          _transact.dueAmount = _bill.amount;
          _transact.status = "Unpaid";
          await _dbHelper.insertTransact(_transact);
          debugPrint("insert no $_number for date $_start");
          _number++;
          _start = new DateTime(_start.year, _start.month + 1, _start.day);

        } while (_start.isBefore(_end));



      }

      else {
        await _dbHelper.updateBill(_bill);
      }


      //Navigate to Bill List
      Navigator.of(this.context).push(
        MaterialPageRoute(builder: (context) => BillList(title: "Bill List")),
      );
    }
  }


  _form() => Expanded(
    child: Container(
//    color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            //TextFormField for Bill Name
            TextFormField(
              controller: _ctrlName,
              decoration: InputDecoration(labelText: "Bill Name"),
              onSaved: (val) => setState(() => _bill.name = val),
              validator: (val) =>
              (val.length == 0 ? 'This field is required' : null),
            ),

            //TextFormField for Bill Category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 7,
                  child: DropdownButtonFormField<String>(

                    decoration: InputDecoration(labelText: "Category",),
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
                    color: Color(0xffF15411),
                  ),
                ),
              ],
            ),

            //TextFormField for Bill startDate
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 7,
                  child: TextFormField(
                    controller: _ctrlStartDate,
                    readOnly: true,
                    decoration: InputDecoration(labelText: "(First) Due Date"),
                    onTap: () => _selectDate(this.context, 1),
                    onSaved: (val) => setState(() => _bill.startDate = val),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(this.context, 1),
                    color: Color(0xffF15411),
                  ),
                ),
              ],
            ),

            //TextFormField for Bill Amount
            TextFormField(
              controller: _ctrlAmount,
              decoration: InputDecoration(labelText: "Default Amount"),
              onSaved: (val) => setState(() => _bill.amount = double.parse(_ctrlAmount.text) as double),
            ),


            //TextFormField for Bill Periodic
            Container(
              child: DropdownButtonFormField<String>(

                decoration: InputDecoration(labelText: "Repeat Periodic"),
//            value: _currentPeriodicSelected,
                items: _listPeriodic.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String newValueSelected) {
                  // Your code to execute, when a menu item is selected from dropdown
                  setState(() {
                    this._currentPeriodicSelected = newValueSelected;
                    _bill.periodic = _currentPeriodicSelected;
                  });
                },
                onSaved: (String newValueSelected) {
                  // Your code to execute, when a menu item is selected from dropdown
                  setState(() {
                    _bill.periodic = _currentPeriodicSelected;
                  });
                },
              ),
            ),

            //TextFormField for Bill endDate
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 7,
                  child: TextFormField(
                    readOnly: true,
                    controller: _ctrlEndDate,
                    decoration: InputDecoration(labelText: "Repeat Until", hintText: "Click icon on the right"),
                    onTap: () => _selectDate(this.context, 2),
                    onSaved: (val) => setState(() => _bill.endDate = val),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(this.context, 2),
                    color: Color(0xffF15411),
                  ),
                ),
              ],
            ),

            //TextFormField for Bill Icon
            Container(
              child: TextFormField(
                controller: _ctrlBillIcon,
                decoration: InputDecoration(labelText: "Bill Icon"),
                onSaved: (val) => setState(() => _bill.billIcon = val),
              ),
            ),

            //Button for Submit & Cancel
            SizedBox(height: 40,),
            Container(
              margin: EdgeInsets.all(10.0),
              width: 200.0,
              height: 50.0,
              child: RaisedButton(
                shape: StadiumBorder(),


                onPressed: () => _onSubmit(),
                child: Text("Save",
                    style: TextStyle(fontSize: 20)),
                color: Color(0xff1AC5A6),
                textColor: Colors.white,
              ),
            ),

          ],
        ),
      ),
    ),
  );


  //Form Reset
  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlCat.clear();
      _ctrlStartDate.clear();
      _ctrlAmount.clear();
      _ctrlPeriodic.clear();
      _ctrlEndDate.clear();
      _ctrlBillIcon.clear();
      _bill.id = null;
    });
  }


//Date Picker
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
//      formattedDate = _date.toString();
      formattedDate = DateFormat('yyy-MM-dd').format(_date);


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
      _myCatList.add('$i ' + element.name);
      _myCats.add(element.name);
      i++;
    });

    int catNo = 1;

    _myCats.forEach((element) {
      catNo++;
    });

    _myCatList.forEach((element) {
    });
  }
}
