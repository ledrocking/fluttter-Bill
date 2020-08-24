class Bill {

  static const tabTransact = 'transact';
  static const colTID = 'tID';
  static const colBillID = 'billID';
  static const colDueDate = 'dueDate';
  static const colDueAmount = 'dueAmount';
  static const colPayDate = 'payDate';
  static const colPayAmount = 'payAmount';
  static const colPayNote = 'payNote';
  static const colPayImage = 'payImage';


  Bill({int myID, this.tID, this.billID, this.dueDate, this.dueAmount, this.payDate, this.payAmount, this.payNote, this.payImage});

  int tID;
  int billID;
  String dueDate;
  String dueAmount;
  String payDate;
  String payAmount;
  String payNote;
  String payImage;


  Bill.fromMap(Map<String, dynamic> map) {
    tID = map[colTID];
    billID = map[colBillID];
    dueDate = map[colDueDate];
    dueAmount = map[colDueAmount];
    payDate = map[colPayDate];
    payAmount = map[colPayAmount];
    payNote = map[colPayNote];
    payImage = map[colPayImage];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colBillID: billID,
      colDueDate: dueDate,
      colDueAmount: dueAmount,
      colPayDate: payDate,
      colPayAmount: payAmount,
      colPayNote: payNote,
      colPayImage: payImage,
    };
    if (tID != null) {
      map[colTID] = tID;
    }
    return map;
  }
}