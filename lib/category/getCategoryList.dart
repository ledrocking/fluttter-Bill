

import 'package:flutter/material.dart';
import 'category_class.dart';
import 'cat_db_helper.dart';

class GetCategoryList {
  MyCategory _myCategory = MyCategory();
  List<MyCategory> _myCategories = [];
  CatDBHelper _catDBHelper;
  List<String> myCatList = [];
  List<String> myGetList = [];

  getList(){
    myGetList = getCatList() as List<String>;
    return myGetList;
  }

/*  getList(){
    getCatList().then((value) => myGetList);
  }*/


  Future<List> getCatList() async {
    List<MyCategory> x = await _catDBHelper.fetchMyCategories();
    _myCategories = x;

    _myCategories.forEach((element) {
      debugPrint(element.name);
      myCatList.add(element.name);
    });
    myCatList.forEach((element) {
      int i = 1;
      debugPrint('Cat $i is: $element');
      i++;
    });

    return myCatList.toList();
  }
}




