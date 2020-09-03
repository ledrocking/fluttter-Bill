

import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/component/NavDrawer.dart';
import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';
import 'category_class.dart';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/bill/bill_form.dart';
import 'category_form.dart';
import 'package:bill_reminder/database/database_helper.dart';

const darkBlueColor = Color(0xff486579);

class SumData extends StatefulWidget {
  SumData({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SumDataState createState() => _SumDataState();
}

class _SumDataState extends State<SumData> {
  List<Map> _mapDataSum = [];
  DatabaseHelper _databaseHelper;
  List<String> myCatList = [];
  DateTime _myDate;

  @override
  void initState() {
    super.initState();
    _myDate = DateTime.now();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
      _refreshMapDataSum();
    });

  }

  @override
  Widget build(BuildContext context) {
    return MyHeader(myTitle: "Category List", myContent: _list(),);
  }

  _refreshMapDataSum() async {
    List<Map> x = await _databaseHelper.transSum(_myDate.toString());
    setState(() {
      _mapDataSum = x;
      _mapDataSum.forEach((element) {
        debugPrint(element.name);
        myCatList.add(element.name);
      });
      myCatList.forEach((element) {
        int i = 1;
        debugPrint('Cat $i is: $element');
        i++;
      });
    });


  }


  _list() => Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle,
                    color: darkBlueColor, size: 40.0),
                title: Text(
                  _mapDataSum[index].name.toUpperCase(),
                  style: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                trailing: IconButton(
                    icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                    onPressed: () async {
                      await _databaseHelper.deleteMyCategory(_mapDataSum[index].id);
                      _refreshMapDataSum();
                    }),

              ),
              Divider(
                height: 5.0,
              )
            ],
          );
        },
        itemCount: _mapDataSum.length,
      ),
    ),
  );
}

class DataSummary {
  String name;
  int age;

  Customer(this.name, this.age);

  @override
  String toString() {
    return '{ ${this.name}, ${this.age} }';
  }
}

