
import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/Transact/transbill_class.dart';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/component/NavDrawer.dart';
import 'package:bill_reminder/category/category_class.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:bill_reminder/component/my_header.dart';
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
    return MyHeader(myTitle: "Update Payment", myContent: _form(),);
  }


  _form() => Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child:Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Text(_transBill.billName,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                )),
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                  color: Color(0xff1AC5A6),
                  width: 1.0,
                ),
              ),

              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Due Amount :  ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xff1AC5A6),
                            fontSize: 16.0,
                          )),
                      Text("${_transBill.dueAmount.toString()}",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Due Date :  ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xff1AC5A6),
                            fontSize: 16.0,
                          )),
                      Text("${DateFormat('EEE, MMM d, ''yy').format(DateTime.parse(_transBill.dueDate))}",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Status :  ",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xff1AC5A6),
                            fontSize: 16.0,
                          )),
                      Text("${_transBill.status}",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 20,),

                ],
              ),

            ),

            SizedBox(height: 10,),



          ],
        ),

      ),
      Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Expanded(
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


                SizedBox(height: 30,),
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
      ),
    ],
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
