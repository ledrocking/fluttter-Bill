

import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/component/NavDrawer.dart';
import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';
import 'mysetting_class.dart';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/bill/bill_form.dart';
import 'mysetting_form.dart';
import 'package:bill_reminder/database/database_helper.dart';

const darkBlueColor = Color(0xff486579);

class MySettingList extends StatefulWidget {
  MySettingList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MySettingListState createState() => _MySettingListState();
}

class _MySettingListState extends State<MySettingList> {
  MySetting _mySetting = MySetting();
  List<MySetting> _mySettings = [];
  DatabaseHelper _databaseHelper;
  List<String> myCatList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
      _refreshMySettingList();
    });

  }

  @override
  Widget build(BuildContext context) {
    return MyHeader(myTitle: "Setting List", myContent: _list(),);
  }

  _refreshMySettingList() async {
    List<MySetting> x = await _databaseHelper.fetchMySettings();
    setState(() {
      _mySettings = x;
      _mySettings.forEach((element) {
        debugPrint(element.password);
        myCatList.add(element.password);
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
                      _mySettings[index].password.toUpperCase(),
                      style: TextStyle(
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    trailing: IconButton(
                        icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                        onPressed: () async {
                          await _databaseHelper.deleteMySetting(_mySettings[index].id);
                          _refreshMySettingList();
                        }),

                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              );
            },
            itemCount: _mySettings.length,
          ),
        ),
      );

}
