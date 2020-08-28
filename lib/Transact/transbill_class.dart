import 'dart:ffi';

import 'package:bill_reminder/Transact/transact_class.dart';
import 'package:bill_reminder/bill/bill_data_class.dart';

class TransBill extends Transact{

  static const colName = 'billName';
  static const colCat = 'billCat';


  TransBill({this.billName, this.billCat});

  String billName;
  String billCat;

  TransBill.fromMap(Map<String, dynamic> map) {
    billName = map[Bill.colName];
    billCat = map[Bill.colCat];

  }
}