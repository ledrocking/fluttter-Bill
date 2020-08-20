import 'dart:io';
import 'category_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CatDBHelper {
  static const _databaseName = 'CategoryDB.db';
  static const _databaseVersion = 1;

  //singleton class
  CatDBHelper._();
  static final CatDBHelper instance = CatDBHelper._();

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
      CREATE TABLE ${MyCategory.tblCategory}(
        ${MyCategory.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${MyCategory.colName} TEXT NOT NULL
      )
      ''');
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

  //myCategory - retrieve Category
  Future<List<MyCategory>> listMyCategories() async {
    Database db = await database;
    List<Map> myCategories = await db.query(MyCategory.tblCategory);
    return myCategories.length == 0
        ? []
        : myCategories.map((x) => MyCategory.fromMap(x)).toList();
  }
}
