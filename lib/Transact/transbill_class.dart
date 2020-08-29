import 'dart:ffi';

import 'package:bill_reminder/bill/bill_data_class.dart';

class TransBill {

  static const tblTransact = 'transact';
  static const colTID = 'tID';
  static const colBillID = 'billID';
  static const colDueDate = 'dueDate';
  static const colDueAmount = 'dueAmount';
  static const colPayDate = 'payDate';
  static const colPayAmount = 'payAmount';
  static const colPayNote = 'payNote';
  static const colPayImage = 'payImage';
  static const colStatus = 'status';
  static const colName = 'billName';
  static const colCat = 'billCat';


  TransBill({int myID, this.tID, this.billID, this.dueDate, this.dueAmount,
    this.payDate, this.payAmount, this.payNote, this.payImage,
    this.status});

  int tID;
  int billID;
  String dueDate;
  double dueAmount;
  String payDate;
  double payAmount;
  String payNote;
  String payImage;
  String status;
  String billName;
  String billCat;

  TransBill.fromMap(Map<String, dynamic> map) {
    tID = map[colTID];
    billID = map[colBillID];
    dueDate = map[colDueDate];
    dueAmount = map[colDueAmount];
    payDate = map[colPayDate];
    payAmount = map[colPayAmount];
    payNote = map[colPayNote];
    payImage = map[colPayImage];
    status = map[colStatus];
    billName = map[Bill.colName];
    billCat = map[Bill.colCat];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colBillID: billID,
      colDueDate: dueDate,
      colDueAmount: dueAmount,
      colPayDate: payDate,
      colPayAmount: payAmount,
      colPayNote: payNote,
      colPayImage: payImage,
      colStatus: status,
      colName: billName,
      colCat: billCat,

    };
    if (tID != null) {
      map[colTID] = tID;
    }
    return map;
  }
}