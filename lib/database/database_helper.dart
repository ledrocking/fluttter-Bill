import 'dart:io';
import 'package:bill_reminder/category/category_class.dart';
import 'package:bill_reminder/bill/bill_data_class.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    //create tables
    await db.execute('''
      CREATE TABLE ${Bill.tblBill}(
        ${Bill.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Bill.colName} TEXT NOT NULL,
        ${Bill.colCat} TEXT NOT NULL,
        ${Bill.colEndDate} TEXT NOT NULL,
        ${Bill.colPeriodic} TEXT NOT NULL,
        ${Bill.colStartDate} TEXT NOT NULL,
        ${Bill.colBillIcon} TEXT
      )
      '''
    );

    await db.execute('''
      CREATE TABLE ${MyCategory.tblCategory}(
      ${MyCategory.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${MyCategory.colName} TEXT NOT NULL
      )
      '''
    );
  }


  //bill - insert
  Future<int> insertBill(Bill bill) async {
    Database db = await database;
    return await db.insert(Bill.tblBill, bill.toMap());
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
  Future<List<Bill>> fetchBills() async {
    Database db = await database;
    List<Map> bills = await db.query(Bill.tblBill);
    return bills.length == 0 ? [] : bills.map((x) => Bill.fromMap(x)).toList();
  }

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
}
