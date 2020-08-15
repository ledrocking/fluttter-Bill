import 'package:bill_reminder/bill_detail.dart';
import 'package:bill_reminder/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/database/bill_data_class.dart';
import 'package:path/path.dart';

import 'edit_form.dart';

const darkBlueColor = Color(0xff486579);

class BillList extends StatefulWidget {
  BillList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BillListState createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  int _counter = 0;

  Bill _bill = Bill();
  List<Bill> _bills = [];
  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshBillList();
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
          children: <Widget>[_list()],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MyBillForm(title: "Add New Bill")
              ),
          );

        },

        tooltip: 'Add Bill',

        child: Icon(Icons.add),

      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _refreshBillList() async {
    List<Bill> x = await _dbHelper.fetchBills();
    setState(() {
      _bills = x;
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
                      _bills[index].name.toUpperCase(),
                      style: TextStyle(
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(_bills[index].amount),
                    trailing: IconButton(
                        icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                        onPressed: () async {
                          await _dbHelper.deleteBill(_bills[index].id);
                          _refreshBillList();
                        }),

                    onTap: (){

                      debugPrint('One bill is clicked');
                      Navigator.of(context).push(
//                        MaterialPageRoute(builder: (context) => EditForm(_bills[index], _bills[index].name)
                        MaterialPageRoute(builder: (context) => BillDetail(_bills[index], _bills[index].name)
                        ),
                      );

                    },

                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              );
            },
            itemCount: _bills.length,
          ),
        ),
      );
}
