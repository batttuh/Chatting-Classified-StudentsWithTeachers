class Ogretmen{
  String ad;
  String soyad;
  int yas;
  String cinsiyet;
  Ogretmen(this.ad,this.soyad,this.yas,this.cinsiyet);
  Ogretmen.fromMap(Map<String,dynamic> ogretmenMap):this(
    ogretmenMap["ad"], ogretmenMap["soyad"], ogretmenMap["yas"], ogretmenMap["cinsiyet"]
  );
  Map<String,dynamic> toMap(){
    return {
      "ad":ad,
      "soyad":soyad,
      "yas":yas,
      "cinsiyet":cinsiyet,
    };
  }
}