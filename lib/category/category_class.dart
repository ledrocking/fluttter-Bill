class MyCategory {

  static const tblCategory = 'myCategory';
  static const colId = 'id';
  static const colName = 'name';
  static const colIcon = 'icon';


  MyCategory({int myID, this.id,this.name});

  int id;
  String name;
  String icon;


  MyCategory.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    icon = map[colIcon];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colIcon: icon,

    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}