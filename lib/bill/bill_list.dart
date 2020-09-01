import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';

import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:bill_reminder/bill/bill_detail.dart';
import 'package:bill_reminder/bill/bill_form.dart';

import 'package:bill_reminder/category/category_list.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../component/NavDrawer.dart';

enum ConfirmDelete { CANCEL, PROCEED }
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
    return MyHeader(myTitle: "My BIlls", myContent: _list(),);
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
                    fontFamily: 'Roboto',
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Wrap(
                  children: [
/*                        Text(DateTime.parse(_bills[index].startDate).toString()),
                        Text("Due : ${DateFormat('dd-MMM-yyy').format(DateTime.parse(_bills[index].startDate))},  "),
                        Text("Due : ${DateFormat('dd-MMM-yyy').format(DateTime.now())},  "),*/

                    Text("Due : ${DateFormat('EEE, MMM d, ''yy').format(DateTime.parse(_bills[index].startDate))},  ",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: darkBlueColor,
                      ),
                    ),
                    Text("Amount : ${_bills[index].amount.toString()}"),
                  ],
                ),
                trailing: IconButton(
                    icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                    onPressed: () async {

                      _asyncConfirmDialog(context, index, _bills[index].name);
/*                          await _dbHelper.deleteTransBill(_bills[index].id);
                          await _dbHelper.deleteBill(_bills[index].id);*/
                      _refreshBillList();
                    }),

                onTap: (){

                  debugPrint('One bill is clicked');
                  Navigator.of(context).push(
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


  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text("This is my message."),
  );


  Future<ConfirmDelete> _asyncConfirmDialog(BuildContext context, int index, String billName) async {
    int _index = index;
    String _billName = billName;
    return showDialog<ConfirmDelete>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $_billName Bill?'),
          content: const Text(
              'Deleting one bill will also delete all payment records for that bill.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmDelete.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('PROCEED'),
              onPressed: () async {
                await _dbHelper.deleteTransBill(_bills[index].id);
                await _dbHelper.deleteBill(_bills[index].id);
                _refreshBillList();
                Navigator.of(context).pop(ConfirmDelete.PROCEED);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("This Bill is Deleted",
                          textAlign: TextAlign.center,
                        ),
                        content: Text(_billName,
                          textAlign: TextAlign.center,)
                    );
                  },
                );
              },
            )
          ],
        );
      },
    );
  }
}
