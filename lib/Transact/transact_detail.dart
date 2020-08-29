import 'package:bill_reminder/Transact/transact_class.dart';
import 'package:bill_reminder/Transact/transbill_class.dart';
import 'package:bill_reminder/bill/NavDrawer.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'transact_update.dart';
import 'dart:io';

import 'package:path/path.dart';


class TransactDetail extends StatefulWidget {
  final String appBarTitle;
  final TransBill transact;

  TransactDetail(this.transact, this.appBarTitle);


    @override
  _TransactDetailState createState() => _TransactDetailState(this.transact, this.appBarTitle);
}

class _TransactDetailState extends State<TransactDetail> {

  String appBarTitle;
  TransBill _transact = TransBill();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();


  _TransactDetailState(this._transact, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
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
            widget.appBarTitle,
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      drawer: NavDrawer(),
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
                Text("Trans ID : ${_transact.tID}"),
                Text("Bill ID : ${_transact.billID}"),
                Text("Bill Name : ${_transact.billName}"),
                Text("Bill Cat : ${_transact.billCat}"),
                Text("Bill Due Date : ${_transact.dueDate..toString()}"),
                Text("Bill Due Amount : ${_transact.dueAmount.toString()}"),
                Text("Bill Pay Amount : ${_transact.payAmount.toString()}"),
                Text("Bill Pay Date : ${_transact.payDate.toString()}"),
                Text("Payment Status : ${_transact.status}"),

                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: () => _onSubmit(),
                    child: Text("Make Payment"),
                    color: darkBlueColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            )),
      );

  _onSubmit()  {
    Navigator.of(this.context).push(
          MaterialPageRoute(builder: (context) => TransactUpdate(_transact, _transact.billName)),
      );
    }
  }
const darkBlueColor = Color(0xff486579);
