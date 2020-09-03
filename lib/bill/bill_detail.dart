import 'package:bill_reminder/component/my_header.dart';
import 'package:flutter/material.dart';
import 'package:bill_reminder/database/database_helper.dart';
import 'dart:io';
import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:bill_reminder/bill/edit_form.dart';

import 'package:path/path.dart';

import '../component/NavDrawer.dart';


class BillDetail extends StatefulWidget {
  final String appBarTitle;
  final Bill bill;

  BillDetail(this.bill, this.appBarTitle);

/*  @override
  State<StatefulWidget> createState() {
    return _BillDetailState(this.bill, this.appBarTitle);*/

    @override
  _BillDetailState createState() => _BillDetailState(this.bill, this.appBarTitle);
}

class _BillDetailState extends State<BillDetail> {
//  int _counter = 0;

  String appBarTitle;
  Bill _bill = Bill();
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();


  _BillDetailState(this._bill, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;

    });
  }

  @override
  Widget build(BuildContext context) {
    return MyHeader(myTitle: "BIll Detail", myContent: _form(),);
  }


  _form() => Expanded(
    child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[

                  Table(
                    border: TableBorder(),
                    columnWidths: {0: FractionColumnWidth(.4), 1: FractionColumnWidth(.6), },
                    children: [
                      TableRow( children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[
                              Text("Bill Name :   ",style: TextStyle(fontSize: 18.0)),

                        ]),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(_bill.name,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                              SizedBox(height: 18,),


                            ]),
                      ]),
                      TableRow( children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[
                              Text("Category :   ",style: TextStyle(fontSize: 18.0)),

                            ]),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(_bill.cat,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                              SizedBox(height: 18,),


                            ]),
                      ]),
                      TableRow( children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[
                              Text("Start Date :   ",style: TextStyle(fontSize: 18.0)),

                            ]),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(_bill.startDate,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                              SizedBox(height: 18,),


                            ]),
                      ]),
                      TableRow( children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[
                              Text("Repeat :   ",style: TextStyle(fontSize: 18.0)),

                            ]),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(_bill.periodic,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                              SizedBox(height: 18,),


                            ]),
                      ]),
                      TableRow( children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[
                              Text("Repeat End :   ",style: TextStyle(fontSize: 18.0)),

                            ]),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(_bill.endDate,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                              SizedBox(height: 18,),


                            ]),
                      ]),
                      TableRow(
                          children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[
                              Text("Icon :   ",style: TextStyle(fontSize: 18.0)),
                            ]),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(_bill.billIcon,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),

                            ]),
                      ]),

                    ],
                  ),

                  SizedBox(height: 30,),
                  Container(
                      width: 100,
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        onPressed: () => _onSubmit(),
                        child: Text("Edit",
                            style: TextStyle(fontSize: 20)),
                        color: Color(0xff1AC5A6),
                        textColor: Colors.white,
                      ),
                  ),
                ],
              )),
        ),
  );

  _onSubmit()  {


      Navigator.of(this.context).push(
          MaterialPageRoute(builder: (context) => EditForm(_bill, _bill.name)),
      );
    }
  }
const darkBlueColor = Color(0xff486579);
