class Bill {

  static const tblBill = 'bill';
  static const colId = 'id';
  static const colName = 'name';
  static const colCat = 'cat';
  static const colStartDate = 'startDate';
  static const colPeriodic = 'periodic';
  static const colEndDate = 'endDate';
  static const colBillIcon = 'billIcon';


  Bill({int myID, this.id,this.name,this.periodic});

  int id;
  String name;
  String cat;
  String endDate;
  String startDate;
  String periodic;
  String billIcon;

  Bill.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    cat = map[colCat];
    endDate = map[colEndDate];
    startDate = map[colStartDate];
    periodic = map[colPeriodic];
    billIcon = map[colBillIcon];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colCat: cat,
      colEndDate: endDate,
      colStartDate: startDate,
      colPeriodic: periodic,
      colBillIcon: billIcon,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}