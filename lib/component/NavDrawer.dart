import 'package:bill_reminder/Transact/transList.dart';
import 'package:bill_reminder/Transact/translist2.dart';
import 'package:bill_reminder/category/category_form.dart';
import 'package:bill_reminder/category/category_list.dart';
import 'package:bill_reminder/setting/mysetting_list.dart';
import 'package:flutter/material.dart';

import '../bill/bill_list.dart';


class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return menuList(context);
  }
}

const darkBlueColor = Color(0xff486579);

Widget menuList(context) {
  return ListView(
    children: [
      ListTile(
        leading: Icon(Icons.home,
            color: darkBlueColor, size: 40.0),
        title: Text("Home",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Home Menu is clicked');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransList(title: "TransList")));
        },
      ),
      ListTile(
        leading: Icon(Icons.credit_card,
            color: darkBlueColor, size: 40.0),
        title: Text("Bill List",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Transaction Menu is clicked');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillList(title: "TransList")));
        },
      ),

      ListTile(
        leading: Icon(Icons.account_circle,
            color: darkBlueColor, size: 40.0),
        title: Text("Tester TransList2",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Transaction Menu is clicked');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransList2(title: "My Bills")));
        },
      ),
      ListTile(
        leading: Icon(Icons.category,
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
      ListTile(
        leading: Icon(Icons.account_circle,
            color: darkBlueColor, size: 40.0),
        title: Text("Add New Category",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Add New Category');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyCategoryForm(title: "Add Category")));
        },
      ),
      ListTile(
        leading: Icon(Icons.settings,
            color: darkBlueColor, size: 40.0),
        title: Text("Setting",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MySettingList(title: "Setting")));
        },
      ),

      ListTile(
        leading: Icon(Icons.insert_chart,
            color: darkBlueColor, size: 40.0),
        title: Text("Report",
          style: TextStyle(
            color: darkBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: (){

          debugPrint('Add New Category');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyCategoryForm(title: "Add Category")));
        },
      ),
    ],
  );
}
