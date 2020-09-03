class PhotoClass {
  int id;
  String photo_name;

  PhotoClass(this.id, this.photo_name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'photo_name': photo_name,
    };
    return map;
  }

  PhotoClass.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photo_name = map['photo_name'];
  }
}