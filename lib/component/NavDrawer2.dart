import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:flutter/material.dart';

import '../bill/bill_list.dart';


class NavDrawer2 extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: menuList(context)
      ),
    );}
}

const darkBlueColor = Color(0xff486579);

Widget menuList(context) {
  return ListView(
    children: [
      ListTile(
        leading: Icon(Icons.account_circle,
            color: darkBlueColor, size: 40.0),
        title: Text("Home",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Home Menu is clicked');
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => BillList(title: "Bill List")),
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.account_circle,
            color: darkBlueColor, size: 40.0),
        title: Text("Transaction List",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Transaction Menu is clicked');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransList(title: "TransList")));
        },
      ),

      ListTile(
        leading: Icon(Icons.account_circle,
            color: darkBlueColor, size: 40.0),
        title: Text("Tester Translist",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Transaction Menu is clicked');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransList(title: "TransList")));
        },
      ),
      ListTile(
        leading: Icon(Icons.account_circle,
            color: darkBlueColor, size: 40.0),
        title: Text("Category",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Category Menu is Clicked');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyCategoryList(title: "Add Category")));
        },
      ),
    ],
  );
}
