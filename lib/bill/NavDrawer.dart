import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:flutter/material.dart';

import 'bill_list.dart';


class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: menuList(context),
    );
  }
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
