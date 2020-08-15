import 'package:bill_reminder/bill_list.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/database/bill_data_class.dart';
import 'package:path/path.dart';

const darkBlueColor = Color(0xff486579);


  Bill _bill = Bill();
  List<Bill> _bills = [];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlAmount = TextEditingController();
  final _ctrlCat = TextEditingController();
  final _ctrlPayAmount = TextEditingController();
  final _ctrlDue = TextEditingController();


  myForm() => Container(
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
            TextFormField(
              controller: _ctrlAmount,
              decoration: InputDecoration(labelText: "Amount"),
              onSaved: (val) => setState(() => _bill.amount = val),
              validator: (val) => (val.length < 2
                  ? 'At least 2 characters required'
                  : null),
            ),
            TextFormField(
              controller: _ctrlCat,
              decoration: InputDecoration(labelText: "Category"),
              onSaved: (val) => setState(() => _bill.cat = val),

            ),
            TextFormField(
              controller: _ctrlPayAmount,
              decoration: InputDecoration(labelText: "Pay Amount"),
              onSaved: (val) => setState(() => _bill.payAmount = val),

            ),
            TextFormField(
              controller: _ctrlDue,
              decoration: InputDecoration(labelText: "Due Date"),
              onSaved: (val) => setState(() => _bill.due = val),

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
    debugPrint('OnSubmit Func is called');
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
      _ctrlCat.clear();
      _ctrlPayAmount.clear();
      _ctrlDue.clear();
      _bill.id = null;
    });
  }
}
