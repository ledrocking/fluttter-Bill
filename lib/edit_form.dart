import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/database/bill_data_class.dart';
import 'package:path/path.dart';

import 'bill_list.dart';

class EditForm extends StatefulWidget {
  final String appBarTitle;
  final Bill bill;

  EditForm(this.bill, this.appBarTitle);


  @override
  _EditFormState createState() => _EditFormState(this.bill, this.appBarTitle);
}

class _EditFormState extends State<EditForm> {
//  int _counter = 0;

  String appBarTitle;
  Bill _bill = Bill();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlAmount = TextEditingController();

  _EditFormState(this._bill, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      if (this._bill != null){
        _ctrlName.text = _bill.name;
        _ctrlAmount.text = _bill.amount;
      }
//      _ctrlName.text = _bill.name;
//      _ctrlAmount.text = _bill.amount;
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
            Text(_bill.name),
            Text(_bill.amount),
            TextFormField(
              controller: _ctrlName,
              decoration: InputDecoration(labelText: "Full Name"),
              onSaved: (val) => setState(() => _bill.name = val),
              validator: (val) =>
              (val.length == 0 ? 'This field is required' : null),
            ),
            TextFormField(
              controller: _ctrlAmount,
              decoration: InputDecoration(labelText: "Amount"),
              onSaved: (val) => setState(() => _bill.amount = val),
              validator: (val) => (val.length < 10
                  ? 'At least 10 characters required'
                  : null),
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
        )),
  );

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_bill.id == null)
        await _dbHelper.insertBill(_bill);
      else
        await _dbHelper.updateBill(_bill);
      _resetForm();
      Navigator.of(this.context).push(
        MaterialPageRoute(builder: (context) => BillList(title: "Bill List")),
      );
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlAmount.clear();
      _bill.id = null;
    });
  }
}

const darkBlueColor = Color(0xff486579);
