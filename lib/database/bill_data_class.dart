class Bill {

  static const tblBill = 'bill';
  static const colId = 'id';
  static const colName = 'name';
  static const colAmount = 'amount';
  static const colCat = 'cat';
  static const colPayAmount = 'payAmount';
  static const colDue = 'due';

  Bill({int myID, this.id,this.name,this.amount});

  int id;
  String name;
  String amount;
  String cat;
  String payAmount;
  String due;

  Bill.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    amount = map[colAmount];
    cat = map[colCat];
    payAmount = map[colPayAmount];
    due = map[colDue];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colAmount: amount,
      colCat: cat,
      colPayAmount: payAmount,
      colDue: due
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}