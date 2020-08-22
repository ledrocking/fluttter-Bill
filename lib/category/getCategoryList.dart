
import 'package:flutter/material.dart';
import 'category_class.dart';
import 'package:bill_reminder/database/database_helper.dart';

class GetCategoryList {
  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];
  DatabaseHelper _dbHelper;
  List<String> myCatList = [];



  Future<List> createCatList() async {
    debugPrint('GetCategoryList createCatList() is called');
    List<MyCategory> x = await _dbHelper.fetchMyCategories();
    _myCategories = x;
    int i = 1;

    _myCategories.forEach((element) {
      debugPrint(element.name);
      myCatList.add(element.name);
    });

    return myCatList;
  }
}




