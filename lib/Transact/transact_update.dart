
import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/Transact/transbill_class.dart';
import 'package:bill_reminder/bill/NavDrawer.dart';
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
  final TransBill transact;

  TransactUpdate(this.transact, this.appBarTitle);


  @override
  _TransactUpdateState createState() => _TransactUpdateState(this.transact, this.appBarTitle);
}

class _TransactUpdateState extends State<TransactUpdate> {
//  int _counter = 0;


  List<String> _myCats = [];
  var _currentItemSelected = '';

  String appBarTitle;
  TransBill _transBill = TransBill();
  Transact _updateData = Transact();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlPayNote= TextEditingController();
  final _ctrlPayImage = TextEditingController();
  final _ctrlPayAmount = TextEditingController();

  _TransactUpdateState(this._transBill, this.appBarTitle);

  @override
  void initState() {
    super.initState();

    setState(() {
      _dbHelper = DatabaseHelper.instance;

      if (this._transBill != null){
        _ctrlPayAmount.text = _transBill.dueAmount.toString();
        _ctrlPayNote.text = _transBill.billName.toString();
        _ctrlPayImage.text = _transBill.billID.toString();


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
      drawer: NavDrawer(),
      body: Center(
        child: ListView(

          children: <Widget>[
            Container(
              child:
              Column(
                children: <Widget>[
                  Text("tID : ${_transBill.tID.toString()}"),
                  Text("Bill ID : ${_transBill.billID.toString()}"),
                  Text("Due Amount : ${_transBill.dueAmount.toString()}"),
                  Text("Due Date : ${_transBill.dueDate}"),
                  Text("Pay Amount : ${_transBill.payAmount.toString()}"),
                  Text("Pay Date  :${_transBill.payDate}"),
                  Text("Status  :${_transBill.status}"),
                  Text("Name : ${_transBill.billName}"),
                  Text("Cat : ${_transBill.billCat}"),
                ],
              ),

            ),
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
            controller: _ctrlPayAmount,
            decoration: InputDecoration(labelText: "Pay Amount"),
            onSaved: (val) => setState(() => _updateData.payAmount = double.parse(val)),
            validator: (val) =>
            (val.length == 0 ? 'This field is required' : null),
          ),

          TextFormField(
            controller: _ctrlPayNote,
            decoration: InputDecoration(labelText: "Payment Note"),
            onSaved: (val) => setState(() => _updateData.payNote),
            validator: (val) =>
            (val.length == 0 ? 'This field is required' : null),
          ),

          TextFormField(
            controller: _ctrlPayImage,
            decoration: InputDecoration(labelText: "Payment Image"),
            onSaved: (val) => setState(() => _updateData.payImage),
            validator: (val) =>
            (val.length == 0 ? 'This field is required' : null),
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

    debugPrint('Update Transaction is called');
    setState(() {
      _updateData.tID = _transBill.tID;
      _updateData.billID = _transBill.billID;
      _updateData.dueDate = _transBill.dueDate;
      _updateData.dueAmount = _transBill.dueAmount;
      _updateData.payDate = DateTime.now().toString();
      _updateData.status = "Paid";
    });


    var form = _formKey.currentState;
    if (form.validate()) {
/*
      _updateData.billID = _transBill.billID;
      _updateData.dueDate = _transBill.dueDate;
      _updateData.dueAmount = _transBill.dueAmount;
      _updateData.payDate = "Now";//DateTime.now().toString();
      _updateData.status = "Paid";
*/

      debugPrint("This is just before insert");
      debugPrint("_transbil  tID :  ${_transBill.tID.toString()}}");
      debugPrint("_transbil bill ID :  ${_transBill.billID.toString()}}");
      debugPrint("");

      debugPrint("_updateData tID :  ${_updateData.tID.toString()}}");
      debugPrint("_updateData bill ID :  ${_updateData.billID.toString()}}");
      debugPrint("_updateData due amount :  ${_updateData.dueAmount.toString()}}");
      debugPrint("_updateData due date :  ${_updateData.dueDate.toString()}}");
      debugPrint("_updateData pay amount :  ${_updateData.payAmount.toString()}}");
      debugPrint("_updateData pay date :  ${_updateData.payDate.toString()}}");
      debugPrint("_updateData status:  ${_updateData.status.toString()}}");
      debugPrint("_updateData Note:  ${_updateData.payNote.toString()}}");
      debugPrint("_updateData Image:  ${_updateData.payImage.toString()}}");


      form.save();
      if (_transBill.tID == null)
        await _dbHelper.insertTransact(_updateData);
      else
        await _dbHelper.updateTransact(_updateData);


      Navigator.of(this.context).push(
        MaterialPageRoute(builder: (context) => TransList(title: "Transact List")),
      );
    }
  }

}
