import 'package:bill_reminder/Transact/transact_list.dart';
import 'package:bill_reminder/category/category_class.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'transact_class.dart';
import 'transact_class.dart';


const darkBlueColor = Color(0xff486579);

class TransactUpdate extends StatefulWidget {
  final String appBarTitle;
  final Transact transact;

  TransactUpdate(this.transact, this.appBarTitle);


  @override
  _TransactUpdateState createState() => _TransactUpdateState(this.transact, this.appBarTitle);
}

class _TransactUpdateState extends State<TransactUpdate> {
//  int _counter = 0;


  List<String> _myCats = [];
  var _currentItemSelected = '';

  String appBarTitle;
  Transact _transact = Transact();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlBillID= TextEditingController();
  final _ctrlDueDate = TextEditingController();
  final _ctrlDueAmount = TextEditingController();
  final _ctrlPayAmount = TextEditingController();
  final _ctrlPayDate = TextEditingController();

  _TransactUpdateState(this._transact, this.appBarTitle);

  @override
  void initState() {
    super.initState();

    setState(() {
      _dbHelper = DatabaseHelper.instance;

      if (this._transact != null){
        _ctrlBillID.text = _transact.billID.toString();
        _ctrlDueDate.text = _transact.dueDate;
        _ctrlDueAmount.text = _transact.dueAmount.toString();
        _ctrlPayAmount.text = _transact.payAmount.toString();
        _ctrlPayDate.text = _transact.payDate;

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
            controller: _ctrlBillID,
            decoration: InputDecoration(labelText: "Full Name"),
            onSaved: (val) => setState(() => _transact.billID = int.parse(val)),
            validator: (val) =>
            (val.length == 0 ? 'This field is required' : null),
          ),

          TextFormField(
            controller: _ctrlDueDate,
            decoration: InputDecoration(labelText: "Full Name"),
            onSaved: (val) => setState(() => _transact.dueDate),
            validator: (val) =>
            (val.length == 0 ? 'This field is required' : null),
          ),


          TextFormField(
            controller: _ctrlDueAmount,
            decoration: InputDecoration(labelText: "Periodic"),
            onSaved: (val) => setState(() => _transact.dueAmount = double.parse(val)),
            validator: (val) => (val.length < 2
                ? 'At least 2 characters required'
                : null),
          ),

          TextFormField(
            controller: _ctrlPayAmount,
            decoration: InputDecoration(labelText: "Transact Icon"),
            onSaved: (val) => setState(() => _transact.payAmount = double.parse(val)),
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
                Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => TransactList(title: "Add Category")));
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
      if (_transact.tID == null)
        await _dbHelper.insertTransact(_transact);
      else
        await _dbHelper.updateTransact(_transact);
//      _resetForm();
      Navigator.of(this.context).push(
        MaterialPageRoute(builder: (context) => TransactList(title: "Transact List")),
      );
    }
  }

}
