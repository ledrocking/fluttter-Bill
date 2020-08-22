import 'package:flutter/material.dart';
import 'dart:io';
import 'category_class.dart';
import 'category_list.dart';
import 'package:bill_reminder/database/database_helper.dart';

const darkBlueColor = Color(0xff486579);

class MyCategoryForm extends StatefulWidget {
  MyCategoryForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyCategoryFormState createState() => _MyCategoryFormState();
}

class _MyCategoryFormState extends State<MyCategoryForm> {
  var _currentItemSelected = '';

  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors
            .white, // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(
            widget.title,
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
                  decoration: InputDecoration(labelText: "Category Name"),
                  onSaved: (val) => setState(() => _myCategory.name = val),
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
      if (_myCategory.id == null)
        await _databaseHelper.insertMyCategory(_myCategory);
      else
        await _databaseHelper.updateMyCategory(_myCategory);
//      _resetForm();
      Navigator.of(this.context).push(
        MaterialPageRoute(
            builder: (context) => MyCategoryList(title: "MyCategory List")),
      );
    }
  }

  Future<List<MyCategory>>getList() async {
    List<MyCategory> xCat = await _databaseHelper.fetchMyCategories();
    debugPrint('My Cat List is:  ${xCat.toString()}');
    return xCat;
  }
}
