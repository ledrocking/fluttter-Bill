import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/database/bill_data_class.dart';
import 'package:path/path.dart';

const darkBlueColor = Color(0xff486579);

class BillDetail extends StatefulWidget {

  final String appBarTitle;
  final int myID;

  BillDetail(this.myID, this.appBarTitle);

  @override
  _BillDetailState createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
