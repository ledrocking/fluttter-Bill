class Bill {

  static const tblBill = 'bill';
  static const colId = 'id';
  static const colName = 'name';
  static const colCat = 'cat';
  static const colStartDate = 'startDate';
  static const colAmount = 'amount';
  static const colPeriodic = 'periodic';
  static const colEndDate = 'endDate';
  static const colBillIcon = 'billIcon';


  Bill({int myID, this.id,this.name,this.periodic});

  int id;
  String name;
  String cat;
  String startDate;
  double amount;
  String periodic;
  String endDate;
  String billIcon;

  Bill.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    cat = map[colCat];
    startDate = map[colStartDate];
    amount = map[colAmount];
    periodic = map[colPeriodic];
    endDate = map[colEndDate];
    billIcon = map[colBillIcon];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colCat: cat,
      colStartDate: startDate,
      colAmount: amount,
      colPeriodic: periodic,
      colEndDate: endDate,
      colBillIcon: billIcon,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}