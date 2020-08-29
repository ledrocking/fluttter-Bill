
import 'package:bill_reminder/Transact/transact_detail.dart';
import 'package:bill_reminder/Transact/transbill_class.dart';
import 'package:bill_reminder/bill/NavDrawer.dart';
import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'package:intl/intl.dart';

import 'transact_class.dart';
import 'package:path_provider/path_provider.dart';
const darkBlueColor = Color(0xff486579);

class TransList extends StatefulWidget {
  TransList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TransListState createState() => _TransListState();
}

class _TransListState extends State<TransList> {

  List<TransBill> _transacts = [];

/*  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _getTransList();
  }*/


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
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),

      drawer: NavDrawer(),

      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text("Period",style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),),
            Text("${DateFormat('MMMM yyy').format(DateTime.parse(DateTime.now().toString()))}",
                    style: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                ),
            ),

            SizedBox(height: 30,),


            Expanded(
              child: FutureBuilder<List<TransBill>>(
                  future: DatabaseHelper.instance.fetchJoin(),
                builder: (context, AsyncSnapshot<List<TransBill>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData == null) {
                          return Text("Done but no data");
                    }
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Text("no data or");
                  }
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData == true) {
                      return ListView.builder(
                        itemCount : snapshot.data.length,
                        itemBuilder: (context, index) {
                          TransBill item = snapshot.data[index];

                          return Column(
                            children: <Widget>[


                              ListTile(
                                leading: Icon(Icons.account_circle,
                                    color: darkBlueColor, size: 40.0),
                                title: Text(item.billName.toString(),
                                  style: TextStyle(
                                    color: darkBlueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Wrap(
                                  children: [
                                    Text("Due : ${DateFormat('EEE, MMM d, ''yy').format(DateTime.parse(item.dueDate))},  "),
                                    Text("Month : ${DateFormat('yM').format(DateTime.parse(item.dueDate))},  "),
                                    Text("in ${(DateTime.parse(item.dueDate)).difference(DateTime.now()).inDays} days "),
                                    Text(": ${item.dueAmount.toString()},"),
                                    Text("Amount : ${item.status}, "),

//                            Text((DateTime.now().difference(DateTime.parse(item.dueDate)).inDays).toString()),
                                  ],
                                ),

                                trailing: IconButton(
                                    icon: Icon(Icons.delete_sweep, color: Colors.redAccent),

                                ),

                                onTap: (){

                                  debugPrint('One transact is clicked');
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => TransactDetail(item, item.billName)
                                    ),
                                  );
                                },
                              ),
                              Divider(
                                height: 20.0,
                              )

                            ],
                          );
                        },
                      );

                    }
                    else {return Align(child: CircularProgressIndicator());}
    }),
            ),
          ],
        ),
      ),

    );}
  List<Bill> _bills = [];


  DatabaseHelper _dbHelper;
}
