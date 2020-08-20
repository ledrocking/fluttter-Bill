class MyCategory {

  static const tblCategory = 'myCategory';
  static const colId = 'id';
  static const colName = 'name';


  MyCategory({int myID, this.id,this.name});

  int id;
  String name;


  MyCategory.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,

    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}