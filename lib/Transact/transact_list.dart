import 'package:bill_reminder/Transact/transact_detail.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/bill/bill_data_class.dart';
import 'package:path/path.dart';

import 'transact_update.dart';

import 'transact_class.dart';

const darkBlueColor = Color(0xff486579);

class TransactList extends StatefulWidget {
  TransactList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TransactListState createState() => _TransactListState();
}

class _TransactListState extends State<TransactList> {
  int _counter = 0;

  Transact _transact = Transact();
  List<Transact> _transacts = [];
  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshTransactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors
            .lightBlue, // Here we take the value from the MyHomePage object that was created by
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
          children:
            <Widget>[_list()],
        ),
      ),


      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _refreshTransactList() async {
    List<Transact> x = await _dbHelper.fetchTransacts();
    setState(() {
      _transacts = x;
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
                      _transacts[index].tID.toString(),
                      style: TextStyle(
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(_transacts[index].dueAmount.toString()),
                    trailing: IconButton(
                        icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                        onPressed: () async {
                          await _dbHelper.deleteTransact(_transacts[index].tID);
                          _refreshTransactList();
                        }),

                    onTap: (){

                      debugPrint('One transact is clicked');
                      Navigator.of(context).push(
//                        MaterialPageRoute(builder: (context) => EditForm(_transacts[index], _transacts[index].name)
                        MaterialPageRoute(builder: (context) => TransactDetail(_transacts[index], _transacts[index].tID.toString())
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
            itemCount: _transacts.length,
          ),
        ),

      );

}
