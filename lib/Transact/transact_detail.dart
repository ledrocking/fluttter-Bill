import 'package:bill_reminder/Transact/transact_class.dart';
import 'package:bill_reminder/Transact/transact_update.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/bill/bill_data_class.dart';
import 'package:path/path.dart';

import 'transact_list.dart';

class TransactDetail extends StatefulWidget {
  final String appBarTitle;
  final Transact transact;

  TransactDetail(this.transact, this.appBarTitle);

/*  @override
  State<StatefulWidget> createState() {
    return _TransactDetailState(this.transact, this.appBarTitle);*/

    @override
  _TransactDetailState createState() => _TransactDetailState(this.transact, this.appBarTitle);
}

class _TransactDetailState extends State<TransactDetail> {
//  int _counter = 0;

  String appBarTitle;
  Transact _transact = Transact();
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



  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(_transact.tID.toString()),
                Text(_transact.billID.toString()),
                Text(_transact.dueDate),
                Text(_transact.dueAmount.toString()),
                Text(_transact.status),

                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: () => _onSubmit(),
                    child: Text("Edit"),
                    color: darkBlueColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            )),
      );

  _onSubmit()  {
/*      Navigator.of(this.context).push(
        MaterialPageRoute(builder: (context) => TransactList(title: "Transact List")),*/

      Navigator.of(this.context).push(
          MaterialPageRoute(builder: (context) => TransactUpdate(_transact, _transact.tID.toString())),
      );
    }
  }
const darkBlueColor = Color(0xff486579);
