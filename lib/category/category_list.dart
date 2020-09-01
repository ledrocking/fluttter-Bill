

import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/component/NavDrawer.dart';
import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';
import 'category_class.dart';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/bill/bill_form.dart';
import 'category_form.dart';
import 'package:bill_reminder/database/database_helper.dart';

const darkBlueColor = Color(0xff486579);

class MyCategoryList extends StatefulWidget {
  MyCategoryList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyCategoryListState createState() => _MyCategoryListState();
}

class _MyCategoryListState extends State<MyCategoryList> {
  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];
  DatabaseHelper _databaseHelper;
  List<String> myCatList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
      _refreshMyCategoryList();
    });

  }

  @override
  Widget build(BuildContext context) {
    return MyHeader(myTitle: "Category List", myContent: _list(),);
  }

  _refreshMyCategoryList() async {
    List<MyCategory> x = await _databaseHelper.fetchMyCategories();
    setState(() {
      _myCategories = x;
      _myCategories.forEach((element) {
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
                      _myCategories[index].name.toUpperCase(),
                      style: TextStyle(
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    trailing: IconButton(
                        icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                        onPressed: () async {
                          await _databaseHelper.deleteMyCategory(_myCategories[index].id);
                          _refreshMyCategoryList();
                        }),

                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              );
            },
            itemCount: _myCategories.length,
          ),
        ),
      );



}
