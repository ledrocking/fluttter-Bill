
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/setting/mysetting_class.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../component/NavDrawer.dart';


const darkBlueColor = Color(0xff486579);

class EditForm extends StatefulWidget {
  final String appBarTitle;
  final MySetting setting;

  EditForm(this.setting, this.appBarTitle);


  @override
  _EditFormState createState() => _EditFormState(this.setting, this.appBarTitle);
}

class _EditFormState extends State<EditForm> {
//  int _counter = 0;


  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];

  List<String> _myCats = [];
  var _currentItemSelected = '';

  String appBarTitle;
  MySetting _setting = MySetting();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlPassword = TextEditingController();
  final _ctrlSymbol = TextEditingController();
  final _ctrlFormat = TextEditingController();

  _EditFormState(this._setting, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _setting.cat;
    setState(() {
      _dbHelper = DatabaseHelper.instance;

      _refreshMyCategoryList();
      if (this._setting != null){
        _ctrlPassword.text = _setting.password;
        _ctrlSymbol.text = _setting.symbol;
        _ctrlFormat.text = _setting.format;
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
            controller: _ctrlPassword,
            decoration: InputDecoration(labelText: "Full Name"),
            onSaved: (val) => setState(() => _setting.password = val),
            validator: (val) =>
            (val.length == 0 ? 'This field is required' : null),
          ),

          DropdownButtonFormField<String>(

            decoration: InputDecoration(labelText: "Category"),
            value: _currentItemSelected,
            items: _myCats.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );

            }).toList(),
            onChanged: (String newValueSelected) {
              // Your code to execute, when a menu item is selected from dropdown
              setState(() {
                this._currentItemSelected = newValueSelected;
                _setting.symbol = _currentItemSelected;
              });
            },
            onSaved: (String newValueSelected) {
              // Your code to execute, when a menu item is selected from dropdown
              setState(() {
                _setting.symbol = _currentItemSelected;
              });
            },
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
                Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => MyCategoryList(title: "Add Category")));
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
      if (_setting.id == null)
        await _dbHelper.insertMySetting(_setting);
      else
        await _dbHelper.updateMySetting(_setting);
//      _resetForm();
      Navigator.of(this.context).push(
        MaterialPageRoute(builder: (context) => MYSettingList(title: "Setting List")),
      );
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlPassword.clear();
      _ctrlSymbol.clear();
      _ctrlFormat.clear();
      _setting.id = null;
    });
  }

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  var formattedDate = "";
  var formattedTime = "";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2024));
    if (picked != null && picked != _date) {
      print('Date selected : ${_date.toString()}');
      setState(() {
        _date = picked;
      });
//    String formattedDate = DateFormat('dd-MMM-yyy – kk:mm').format(_date);
      formattedDate = DateFormat('yyy-MM-dd').format(_date);
      debugPrint("$formattedDate");
      _ctrlFormat.text = formattedDate;
      return formattedDate;
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 00),
    );
    if (picked != null && picked != _time) {
      print('Time selected : ${_time.toString()}');
      setState(() {
        _time = picked;
      });
      formattedTime = _time.format(context);
      debugPrint("$formattedTime");
      _ctrlFormat.text = formattedDate + " " + formattedTime;
    }
  }

  List<String> _myCatList = [];

  _refreshMyCategoryList() async {
    List<MyCategory> x = await _dbHelper.fetchMyCategories();
    setState(() {
      _myCategories = x;
    });
    int i = 1;
    _myCategories.forEach((element) {
      debugPrint(element.name);
      _myCatList.add('$i ' + element.name);
      _myCats.add(element.name);
      i++;
    });
    debugPrint('This is from refresh myCats');
    int catNo = 1;

    _myCats.forEach((element) {
      debugPrint('Cat No $catNo: $element');
      catNo++;
    });
    debugPrint('This is from refresh myCatList');
    _myCatList.forEach((element) {
      debugPrint('Cat is: $element');
    });
  }
}
