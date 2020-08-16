import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/database/bill_data_class.dart';
import 'package:path/path.dart';

import 'bill_list.dart';
import 'edit_form.dart';

class BillDetail extends StatefulWidget {
  final String appBarTitle;
  final Bill bill;

  BillDetail(this.bill, this.appBarTitle);

/*  @override
  State<StatefulWidget> createState() {
    return _BillDetailState(this.bill, this.appBarTitle);*/

    @override
  _BillDetailState createState() => _BillDetailState(this.bill, this.appBarTitle);
}

class _BillDetailState extends State<BillDetail> {
//  int _counter = 0;

  String appBarTitle;
  Bill _bill = Bill();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();


  _BillDetailState(this._bill, this.appBarTitle);

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
            .white, // Here we take the value from the MyHomePage object that was created by
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
                Text(_bill.id.toString()),
                Text(_bill.name),
                Text(_bill.amount),
                Text(_bill.cat.toString()),
                Text(_bill.payAmount),
                Text(_bill.due),

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
        MaterialPageRoute(builder: (context) => BillList(title: "Bill List")),*/

      Navigator.of(this.context).push(
          MaterialPageRoute(builder: (context) => EditForm(_bill, _bill.name)),
      );
    }
  }
const darkBlueColor = Color(0xff486579);
