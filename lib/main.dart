import 'package:flutter/material.dart';
import 'Transact/transList.dart';
import 'bill/bill_list.dart';
import 'component/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bills Reminder',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      //home: MyHomePage(title: 'Bill Reminder'),
      home: TransList(),

    );
  }
}
