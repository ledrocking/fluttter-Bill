import 'package:bill_reminder/Transact/transact_class.dart';
import 'package:bill_reminder/category/category_class.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../component/NavDrawer.dart';
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

  Transact _transact = Transact();

  List<String> _listPeriodic = ["Monthly", "Biweekly", "Weekly", "No Repeat"];
  List<String> _myCats = [];

  var _currentItemSelected = '';
  var _currentPeriodicSelected = '';


  String oldEndDate = "";

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
      _currentPeriodicSelected = _bill.periodic;

      if (this._bill != null){
        _ctrlName.text = _bill.name;
        _ctrlCat.text = _bill.cat;
        _ctrlStartDate.text = _bill.startDate;
        _ctrlPeriodic.text = _bill.periodic;
        _ctrlEndDate.text = _bill.endDate;
        _ctrlBillIcon.text = _bill.billIcon;
        oldEndDate = _bill.endDate;

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MyHeader(myTitle: "Edit BIlls", myContent: _form(),);
  }

  _form() => Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Form(
        key: _formKey,
        child: ListView(
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

            //TextFormField for Bill Periodic
            Container(
              child: DropdownButtonFormField<String>(

                decoration: InputDecoration(labelText: "Repeat Periodic"),
                value: _currentPeriodicSelected,
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



            TextFormField(
              controller: _ctrlBillIcon,
              decoration: InputDecoration(labelText: "Bill Icon"),
              onSaved: (val) => setState(() => _bill.billIcon = val),
            ),

            SizedBox(height: 40,),
            Container(
              margin: EdgeInsets.all(10.0),
              width: 200.0,
              height: 50.0,
              child: RaisedButton(
                shape: StadiumBorder(),


                onPressed: () => _onSubmit(oldEndDate),
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

  _onSubmit(oldEndDate) async {
    String myOldEndDate = oldEndDate;

    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
        await _dbHelper.updateBill(_bill);

      debugPrint('Old End Date is $myOldEndDate');
      debugPrint('New End Date is ${_ctrlEndDate.text}');

      //if End Date is change
      if (DateTime.parse(myOldEndDate).difference(DateTime.parse(_ctrlEndDate.text)).inDays >= 0) {
        debugPrint('New Date is Earlier');
        //New Date is earlier. Therefore delete transaction from new date to old date
        // what start date/due date is also change? It safe to delete transaction from now onward, then create new one
      }
      else {
        debugPrint('New Date is later');
        //New Date is later. Therefore create transaction from old date to new date.
        // what start date/due date is also change? It safe to delete transaction from now onward, then create new one
      }


      var _start = DateTime.parse(_bill.startDate);

      var _endDelete = DateTime.parse(myOldEndDate);
      _endDelete = new DateTime(_endDelete.year, _endDelete.month + 2, _endDelete.day + 1);

      var _endInsert = DateTime.parse(_bill.endDate);
      _endInsert = new DateTime(_endInsert.year, _endInsert.month, _endInsert.day + 1);

      var _periodic = "Monthly";
      int _number = 1;

      // Data prep for delete and insert transaction
      _transact.billID = _bill.id;
      _transact.dueAmount = _bill.amount;
      _transact.status = "Unpaid";

      //Delete Transact data Table from now onward
      await _dbHelper.deleteTransBillOnward(_bill.id, _endDelete.toString());

      //Insert data into Transact Table from now to new en date
      do {
        _transact.dueDate = _start.toString();
        await _dbHelper.insertTransact(_transact);
        debugPrint("insert no $_number for date $_start");
        _number++;
        _start = new DateTime(_start.year, _start.month + 1, _start.day);

      } while (_start.isBefore(_endInsert));




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
