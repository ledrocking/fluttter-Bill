class MySetting {

  static const tblSetting = 'mySetting';
  static const colId = 'id';
  static const colPassword = 'password';
  static const colSymbol = 'symbol';
  static const colFormat = 'format';


  MySetting({int myID, this.id,this.password,this.symbol, this.format});

  int id;
  String password;
  String symbol;
  String format;


  MySetting.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    password = map[colPassword];
    symbol = map[colSymbol];
    format = map[colFormat];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colPassword: password,
      colSymbol: symbol,
      colFormat: format,

    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}