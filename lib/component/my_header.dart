import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:flutter/material.dart';

import '../bill/bill_list.dart';
import 'NavDrawer.dart';


class MyHeader extends StatefulWidget {
  MyHeader({Key key, this.myTitle, this.myContent}) : super(key: key);

  final String myTitle;
  final Widget myContent;

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
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
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TransList(title: "TransList")));
                  },

                ),
                Flexible(fit: FlexFit.tight, child: SizedBox()),
                IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },

                ),
              ],
            ),


            Text(widget.myTitle, style: TextStyle(
              fontFamily: 'RockSalt',
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 28.0,
            ),),
            SizedBox(height: 40,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0)),
                ),
                child: Column(
                  children: <Widget>[
                    widget.myContent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


