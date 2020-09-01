import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/component/NavDrawer.dart';
import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'mysetting_class.dart';
import 'mysetting_list.dart';
import 'package:bill_reminder/database/database_helper.dart';

const darkBlueColor = Color(0xff486579);

class MySettingForm extends StatefulWidget {
  MySettingForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MySettingFormState createState() => _MySettingFormState();
}

class _MySettingFormState extends State<MySettingForm> {
  var _currentItemSelected = '';

  MySetting _mySetting = MySetting();
  List<MySetting> _mySettings = [];
  DatabaseHelper _databaseHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyHeader(myTitle: "Add New Setting", myContent: _form(),);
  }

  _form() => Expanded(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _ctrlName,
                  decoration: InputDecoration(labelText: "Setting Name"),
                  onSaved: (val) => setState(() => _mySetting.password = val),
                  validator: (val) =>
                      (val.length == 0 ? 'This field is required' : null),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: () => _onSubmitCat(),
                    child: Text("Submit"),
                    color: darkBlueColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  _onSubmitCat() async {
    debugPrint('OnSubmit Func is called');
    getList();


    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_mySetting.id == null)
        await _databaseHelper.insertMySetting(_mySetting);
      else
        await _databaseHelper.updateMySetting(_mySetting);
//      _resetForm();
      Navigator.of(this.context).push(
        MaterialPageRoute(
            builder: (context) => MySettingList(title: "MySetting List")),
      );
    }
  }

  Future<List<MySetting>>getList() async {
    List<MySetting> xCat = await _databaseHelper.fetchMySettings();
    debugPrint('My Cat List is:  ${xCat.toString()}');
    return xCat;
  }
}
