import 'dart:io';
import 'package:bill_reminder/category/category_class.dart';
import 'package:bill_reminder/bill/bill_data_class.dart';
import 'package:bill_reminder/Transact/transact_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bill_reminder/Transact/transbill_class.dart';
import 'package:bill_reminder/setting/mysetting_class.dart';

class DatabaseHelper {
  static const _databaseName = 'BillDatabase.db';
  static const _databaseVersion = 3;

  //singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    print(dbPath);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    //create Tables Bill
    await db.execute('''
      CREATE TABLE ${Bill.tblBill}(
        ${Bill.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Bill.colName} TEXT NOT NULL,
        ${Bill.colCat} TEXT NOT NULL,
        ${Bill.colStartDate} TEXT NOT NULL,
        ${Bill.colAmount} REAL,
        ${Bill.colPeriodic} TEXT,
        ${Bill.colEndDate} TEXT,
        ${Bill.colBillIcon} TEXT
      )
      '''
    );

    //Create Table Category
    await db.execute('''
      CREATE TABLE ${MyCategory.tblCategory}(
      ${MyCategory.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${MyCategory.colName} TEXT NOT NULL,
      ${MyCategory.colIcon} TEXT
      )
      '''
    );

    //create Tables Transaction
    await db.execute('''
      CREATE TABLE ${Transact.tblTransact}(
        ${Transact.colTID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Transact.colBillID} INTEGER NOT NULL,
        ${Transact.colDueDate} TEXT NOT NULL,
        ${Transact.colDueAmount} REAL,
        ${Transact.colPayDate} TEXT,
        ${Transact.colPayAmount} REAL,
        ${Transact.colPayNote} TEXT,
        ${Transact.colPayImage} TEXT,
        ${Transact.colStatus} TEXT
      )
      '''
    );

    //Create Table Setting
    await db.execute('''
      CREATE TABLE ${MySetting.tblSetting}(
      ${MySetting.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${MySetting.colPassword} TEXT,
      ${MySetting.colSymbol} TEXT
      ${MySetting.colFormat} TEXT
      )
      '''
    );

  }




  // CRUD BILL TABLE
  //bill - insert
  Future<int> insertBill(Bill bill) async {
    Database db = await database;
    return await db.insert(Bill.tblBill, bill.toMap());
  }

  Future<int> insertBill2(Bill bill) async {
    Database db = await database;
    int insertedId = await db.insert(Bill.tblBill, bill.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,);
    debugPrint('inserted ID : $insertedId');
    return insertedId;
  }

  //bill - update
  Future<int> updateBill(Bill bill) async {
    Database db = await database;
    return await db.update(Bill.tblBill, bill.toMap(),
        where: '${Bill.colId}=?', whereArgs: [bill.id]);
  }

  //bill - delete
  Future<int> deleteBill(int id) async {
    Database db = await database;
    return await db
        .delete(Bill.tblBill, where: '${Bill.colId}=?', whereArgs: [id]);
  }

  //bill - retrieve all
/*  Future<List<Bill>> fetchBills() async {
    Database db = await database;
    List<Map> bills = await db.query(Bill.tblBill);
    return bills.length == 0 ? [] : bills.map((x) => Bill.fromMap(x)).toList();
  }*/

//         WHERE ${DateTime.parse(Bill.colStartDate)} < ${DateTime.now()}
  //ok            WHERE ${(Bill.colAmount)} < 500
  //ok         WHERE ${DateTime.parse(Bill.colStartDate)} < ${DateTime.now()}


  //bill - retrieve all
  Future<List<Bill>> fetchBills() async {
    Database db = await database;
    List<Map> bills = await db.rawQuery(
        '''
        SELECT * FROM ${Bill.tblBill}        
        '''
    );
    return bills.length == 0 ? [] : bills.map((x) => Bill.fromMap(x)).toList();
  }


  //bill - retrieve specific Bill
  Future<List<Bill>> fetch1Bill(int id) async {
    Database db = await database;
    List<Map> bills = await db.query(Bill.tblBill, where: '${Bill.colId}=?', whereArgs: [id]);
    return bills.length == 0 ? [] : bills.map((x) => Bill.fromMap(x)).toList();
  }


  //--------------------------------------------------------------------------
  //CRUD MyCategory TABLE
  //myCategory - insert
  Future<int> insertMyCategory(MyCategory myCategory) async {
    Database db = await database;
    return await db.insert(MyCategory.tblCategory, myCategory.toMap());
  }

  //myCategory - update
  Future<int> updateMyCategory(MyCategory myCategory) async {
    Database db = await database;
    return await db.update(MyCategory.tblCategory, myCategory.toMap(),
        where: '${MyCategory.colId}=?', whereArgs: [myCategory.id]);
  }

  //myCategory - delete
  Future<int> deleteMyCategory(int id) async {
    Database db = await database;
    return await db.delete(MyCategory.tblCategory,
        where: '${MyCategory.colId}=?', whereArgs: [id]);
  }

  //myCategory - retrieve all
  Future<List<MyCategory>> fetchMyCategories() async {
    Database db = await database;
    List<Map> myCategories = await db.query(MyCategory.tblCategory);
    return myCategories.length == 0
        ? []
        : myCategories.map((x) => MyCategory.fromMap(x)).toList();
  }

  //--------------------------------------------------------------------------
  //CRUD MySetting TABLE
  //mySetting - insert
  Future<int> insertMySetting(MySetting mySetting) async {
    Database db = await database;
    return await db.insert(MySetting.tblSetting, mySetting.toMap());
  }

  //mySetting - update
  Future<int> updateMySetting(MySetting mySetting) async {
    Database db = await database;
    return await db.update(MySetting.tblSetting, mySetting.toMap(),
        where: '${MySetting.colId}=?', whereArgs: [mySetting.id]);
  }

  //mySetting - delete
  Future<int> deleteMySetting(int id) async {
    Database db = await database;
    return await db.delete(MySetting.tblSetting,
        where: '${MySetting.colId}=?', whereArgs: [id]);
  }

  //mySetting - retrieve all
  Future<List<MySetting>> fetchMySettings() async {
    Database db = await database;
    List<Map> mySettings = await db.query(MySetting.tblSetting);
    return mySettings.length == 0
        ? []
        : mySettings.map((x) => MySetting.fromMap(x)).toList();
  }


  //--------------------------------------------------------------------------
  //CRUD Transact TABLE
  //transact - insert
  Future<int> insertTransact(Transact transact) async {
    Database db = await database;
    return await db.insert(Transact.tblTransact, transact.toMap());
  }

  //transact - update
  Future<int> updateTransact(Transact transact) async {
    Database db = await database;
    return await db.update(Transact.tblTransact, transact.toMap(),
        where: '${Transact.colTID}=?', whereArgs: [transact.tID]);
  }

  //transact - delete
  Future<int> deleteTransact(int tID) async {
    Database db = await database;
    return await db.delete(Transact.tblTransact,
        where: '${Transact.colTID}=?', whereArgs: [tID]);
  }

  //transact - delete all transaction for certain bill (when bill is deleted)
  Future<int> deleteTransBill(int billID) async {
    Database db = await database;
    return await db.delete(Transact.tblTransact,
        where: '${Transact.colBillID}=?', whereArgs: [billID]);
  }

  //transact - retrieve all
  Future<List<Transact>> fetchTransacts() async {
    Database db = await database;
    List<Map> transacts = await db.query(Transact.tblTransact);
    return transacts.length == 0
        ? []
        : transacts.map((x) => Transact.fromMap(x)).toList();
  }

//_____________________________________________________________________________

  //EXPERIMENT
//      WHERE DateFormat('yM').format(DateTime.parse(${Transact.colDueDate})) = ${DateFormat('yM').format(DateTime.parse(DateTime.now()))}
//  WHERE DateFormat('yM').format(DateTime.parse(${Transact.colDueDate})) = DateFormat('yM').format(DateTime.parse(${DateTime.now()}))
//ok        WHERE ${Transact.colDueAmount} < 1000
//ok               AND ${DateTime.parse(Transact.colDueDate)} < ${DateTime.now()}
  //         > ${DateFormat('yyyy-MM-dd').format(DateTime.parse(DateTime.now().toString()))}
  //        WHERE  "2020-08-01" < DateTime.parse(DateTime.now().toString())
  //OK              WHERE ${Transact.colDueDate} < "$_date"
  //ok         WHERE $_myDue BETWEEN  "2020-07-01" AND "$_date"
  //OK         WHERE $_myDue BETWEEN  "2020-07-01" AND "2020-12-01"
  // OK         WHERE $_myDue BETWEEN  "2020-07-01" AND DATE('$_date','start of month','+1 month','-1 day')

// SELECT JOIN TABLE TRANSACT & BILL
  Future<List<TransBill>> fetchJoin() async {
    Database db = await database;
 //   String _date = '2020-10-29';
    String _date = DateFormat('yyyy-MM-dd').format(DateTime.parse(DateTime.now().toString()));
    String _date1 = DateFormat('yyyy-MM-dd').format(DateTime.parse(DateTime.now().toString()));
    String _date2 = DateFormat('yyyy-MM-dd').format(DateTime.parse(DateTime.now().toString()));
    String _myDue = Transact.colDueDate;
//    String _myDue = DateFormat('yyyy-MM-dd').format(DateTime.parse(Transact.colDueDate));
//    String _myDue2 = DateFormat('yyy-MM-dd').format(DateTime.parse(_myDue));

 /*   String _date = DateFormat('yyyy-MM').format(DateTime.parse(DateTime.now().toString()));
    String _myDue = DateFormat('yyyy-MM').format(DateTime.parse(Transact.colDueDate.toString()));
*/
    List<Map> transBills  = await db.rawQuery(
        '''
        SELECT ${TransBill.colTID}, ${TransBill.colBillID}, ${Transact.colDueDate}, ${Transact.colDueAmount},
        ${Transact.colPayDate}, ${Transact.colPayAmount}, ${Transact.colPayNote},
        ${Transact.colPayImage}, ${Transact.colStatus}, ${Bill.colName},  ${Bill.colCat}
        FROM ${Transact.tblTransact} 
        INNER JOIN ${Bill.tblBill}
        ON ${Bill.colId} = ${Transact.colBillID} 
        WHERE $_myDue BETWEEN  DATE('$_date','start of month','+0 month','-1 day') AND DATE('$_date','start of month','+1 month','-0 day')
        '''
    );

    List<TransBill> myList = transBills.length == 0
    ? [] : transBills.map((x) => TransBill.fromMap(x)).toList();

    if (myList ==null){
      debugPrint("No Data from join");
    }

    debugPrint("var _date : $_date");

    debugPrint("Original Now     : ${DateTime.now()}");

    debugPrint("Not formatted : ${(myList[1].dueDate)}");
    debugPrint("Month Format : ${DateFormat('yyyy-MM').format(DateTime.parse(DateTime.now().toString()))}");
    debugPrint("Month Format : ${DateFormat('MM-yyyy').format(DateTime.parse(DateTime.now().toString()))}");

    return myList;
    }



  // SELECT JOIN TABLE TRANSACT & BILL
  Future<List<TransBill>> fetchJoin2(period) async {
    String _period = period;
    String myPeriod = DateTime.now().toString();


    Database db = await database;
    String _date = DateFormat('yyyy-MM-dd').format(DateTime.parse(_period));
    String _date1 = DateFormat('yyyy-MM-dd').format(DateTime.parse(DateTime.now().toString()));
    String _date2 = DateFormat('yyyy-MM-dd').format(DateTime.parse(DateTime.now().toString()));
    String _myDue = Transact.colDueDate;

    List<Map> transBills  = await db.rawQuery(
        '''
        SELECT ${TransBill.colTID}, ${TransBill.colBillID}, ${Transact.colDueDate}, ${Transact.colDueAmount},
        ${Transact.colPayDate}, ${Transact.colPayAmount}, ${Transact.colPayNote},
        ${Transact.colPayImage}, ${Transact.colStatus}, ${Bill.colName},  ${Bill.colCat}
        FROM ${Transact.tblTransact} 
        INNER JOIN ${Bill.tblBill}
        ON ${Bill.colId} = ${Transact.colBillID} 
        WHERE $_myDue BETWEEN  DATE('$_date','start of month','+0 month','-0 day') 
        AND DATE('$_date','start of month','+1 month','-0 day')
        ORDER BY ${Transact.colStatus} DESc, ${Transact.colDueDate} ASC
        '''
    );

    List<TransBill> myList = transBills.length == 0
        ? [] : transBills.map((x) => TransBill.fromMap(x)).toList();

    if (myList ==null){
      debugPrint("No Data from join");
    }
    return myList;
  }
}
