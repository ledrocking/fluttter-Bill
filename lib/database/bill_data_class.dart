class Bill {

  static const tblBill = 'bill';
  static const colId = 'id';
  static const colName = 'name';
  static const colAmount = 'amount';

  Bill({int myID, this.id,this.name,this.amount});

  int id;
  String name;
  String amount;

  Bill.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    amount = map[colAmount];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colAmount: amount};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}