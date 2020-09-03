

import 'dart:ffi';

import 'package:bill_reminder/Transact/transact_detail.dart';
import 'package:bill_reminder/Transact/transact_update.dart';
import 'package:bill_reminder/Transact/transbill_class.dart';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/component/NavDrawer.dart';
import 'file:///C:/Users/adel.rahadi/FlutterProjects/bill_reminder/lib/component/NavDrawer2.dart';
import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:bill_reminder/bill/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'package:intl/intl.dart';
import 'transact_class.dart';
import 'package:path_provider/path_provider.dart';
const darkBlueColor = Color(0xff486579);

class TransList2 extends StatefulWidget {
  TransList2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TransList2State createState() => _TransList2State();
}

class _TransList2State extends State<TransList2> {

  List<TransBill> _transacts = [];
  String _date = DateTime.now().toString();
  DateTime _myDate;
  double myDue = 0;
  String _period = DateTime.now().toString();
  String _periodName = DateFormat('MMMM yyy').format(DateTime.parse(DateTime.now().toString()));

  List<Color> _colors = [Color(0xff5DEED4).withOpacity(0.5), Color(0xff1857B7)];
  List<double> _stops = [0.0, 0.7];


  @override
  void initState() {
    super.initState();
    _myDate = DateTime.now();
    setState(() {
    });
  }

  List<double> sumData = [];
  Future getDataSum(List<TransBill> data) async {

    dueTotal = 0;
    paidTotal = 0;
    totItem = 0;
    paidItem = 0;

    List<TransBill> _data = data;
    _data.forEach((element) {
      //Total Due Amount
      dueTotal =  dueTotal + element.dueAmount;
      totItem =  totItem + 1;

      //Total Paid amount
      if (element.payAmount!=null) {
        paidTotal =  paidTotal + element.payAmount;
        paidItem = paidItem + 1;
      }
    });

    sumData.add(paidTotal);
    sumData.add(dueTotal);

    debugPrint("Total Item Number from getDataSum : $totItem");
    debugPrint("Total Paid Item Number from getDataSum : $paidItem");
    debugPrint("DueTotal from getDataSum $dueTotal");
    debugPrint("PaidTotal from getDataSum $paidTotal");
    debugPrint("Unpaid Total Amount from getDataSum ${(dueTotal - paidTotal)}");

    return sumData;
  }


  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: NavDrawer(),
      ),

      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff5DEED4).withOpacity(1), Color(0xff1857B7)],
              begin: Alignment.centerLeft,
              end: new Alignment(0.8, -0.6),
              //stops: _stops,

            )
        ),
        child: Column(
          children: [

            SizedBox(height: 30,),

            Container(

              //            margin: EdgeInsets.only(left: 2.0,top:20.0),
              alignment: Alignment.topRight,
              height: 25,
              child: IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },

              ),
            ),


            Text("My Bills",style: TextStyle(
              fontFamily: 'RockSalt',
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 28.0,
            ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => changePeriod(-1),
                  color: Colors.redAccent,
                ),
                SizedBox(width: 20,),
                Text("$_periodName",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(width: 20,),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () => changePeriod(1),
                  color: Colors.redAccent,
                ),

              ],
            ),






            SizedBox(height: 30,),


            Expanded(
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0)),
                ),
                child: FutureBuilder<List<TransBill>>(
                    future: DatabaseHelper.instance.fetchJoin2(_myDate.toString()),
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

                        getDataSum(snapshot.data);
                        myDue = dueTotal;


                        return ListView.builder(
  //                        itemCount : snapshot.data.length,
                          itemCount : snapshot.data == null ? 1 : snapshot.data.length + 1,
                          itemBuilder: (context, index) {

                            if (index == 0) {
                              // return the header
                              return new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text ("Total Paid"),
                                      Text ("$paidTotal"),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text ("Total Due"),
                                      Text ("$myDue"),
                                    ],
                                  ),
                                ],
                              );
                            }

                            index = index - 1;
                            var row = snapshot.data[index];

                            TransBill item = row;
                            return Card(
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: Column(
                                children: <Widget>[

                                  ListTile(
                                    leading: Icon(Icons.account_circle,
                                        color: darkBlueColor, size: 40.0),
                                    title: Text(item.billName.toString(),
                                      style: TextStyle(
                                        color: Color(0xff4F4F4F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                    subtitle: Wrap(
                                      children: [detailInfo(item),
/*                                        Text("(${(DateTime.parse(item.dueDate)).difference(DateTime.now()).inDays} days) "),
                                        Text("Amount : ${item.dueAmount.toString()},"),*/

                                      ],
                                    ),

                                    trailing: Column(
                                      children: [
                                        IconButton(
                                          icon: getIcon(context, item.status, item, item.billName),

                                        ),
                                      ],
                                    ),

                                    onTap: (){

                                      debugPrint('One transact is clicked');
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => TransactUpdate(item, item.billName)
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 10.0,
                                  ),
                                ],

                              ),


                            );

                          },
                        );

                      }
                      else {return Align(child: CircularProgressIndicator());}
                    }

                    ),
              ),
            ),

          ],


        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyForm(title: "Add New Bill")

            ),
          );
        },
        tooltip: 'Add Bill',
        child: Icon(Icons.add),

      ),
    );}
  List<Bill> _bills = [];


  DatabaseHelper _dbHelper;

  changePeriod(int source) {
    int _source = source;
    debugPrint("Next Period is clicked");
    debugPrint("Ori _myDate before is : $_myDate");
 //   dueTotal = 0;
    setState(() {
      if (_source == 1) {

        _myDate = new DateTime(_myDate.year, _myDate.month + 1, _myDate.day);

      }
      else {
        _myDate = new DateTime(_myDate.year, _myDate.month - 1, _myDate.day);

      }
      _periodName = DateFormat('MMMM yyy').format(DateTime.parse(_myDate.toString()));
    });
    debugPrint("Now _myDate is : $_myDate");
  }
}



  double dueTotal = 0;
  double paidTotal = 0;
  int totItem = 0;
  int paidItem = 0;


final oCcy = new NumberFormat("#,##0.00", "en_US");
final formatCurrency = new NumberFormat.simpleCurrency();
String currSymbol = "Rp.";

detailInfo(TransBill item) {

  int daysLeft = (DateTime.parse(item.dueDate)).difference(DateTime.now()).inDays;
  String daysLeftShow;
  if (daysLeft > 1) {daysLeftShow = "${-daysLeft} days" ;}
  if (daysLeft == 1) {daysLeftShow = "${-daysLeft} day" ;}
  if (daysLeft == 0) {daysLeftShow = "$daysLeft day";}
  if (daysLeft == -1) {daysLeftShow = "+${-daysLeft} day" ;}
  if (daysLeft < -1) {daysLeftShow = "+${-daysLeft} days" ;}




  switch (item.status) {
    case "Paid":
      return
        Wrap(
          children: [

            Text("Paid on ",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xff1AC5A6),
                  fontWeight: FontWeight.bold,
                )),
            Text(DateFormat('EEE, MMM d, ''yy').format(DateTime.parse(item.payDate))),
            Text(",   "),
            //           Text("\t "),

            Text("Amount paid "),
            Text("${formatCurrency.format(item.payAmount)}",
                style: TextStyle(
                  color: Color(0xff1AC5A6),
                  fontWeight: FontWeight.bold,
                )
            ),
          ],
        );
      break;
    default:
      return
        Wrap(
          children: [
            Text("Due : ${DateFormat('EEE, MMM d, ''yy').format(DateTime.parse(item.dueDate))},  "),
            //          Text("(${(DateTime.parse(item.dueDate)).difference(DateTime.now()).inDays} "

            Text("($daysLeftShow)",
              style: TextStyle(
                fontFamily: 'Roboto',
                color: getColor(daysLeft),
                fontWeight: FontWeight.bold,
//                fontSize: 20.0,
              ),
            ),
            Text("Amount "),
            Text(r"$"),
            Text(" ${oCcy.format(item.dueAmount)}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                )),
          ],
        );

  }

}

getIcon(context, String status, TransBill item, String billName) {

  int daysLeft = (DateTime.parse(item.dueDate)).difference(DateTime.now()).inDays;
  switch (status) {
    case "Paid":
      return Icon(Icons.check_circle,
          color: Color(0xff1AC5A6));
      break;
    case "Partial":
      return IconButton(
          icon: Icon(Icons.invert_colors),
          color: getColor(daysLeft),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TransactUpdate(item, billName)));
          }
      );
      break;

    default:
      return IconButton(
          icon: Icon(Icons.update),
          color: getColor(daysLeft),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TransactUpdate(item, billName)));
          }
      );
  }
}

Color getColor (int daysLeft) {
  int _daysLeft = daysLeft;
  if  (daysLeft > 0) {
    return Colors.lightBlue;
  }
  else return Colors.deepOrange;
}


