

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/model/ogrenci.dart';
import 'package:riverpod/riverpod.dart';

class ogrencilerRepo extends ChangeNotifier{

  List ogrenciler=[
    Ogrenci("Batuhan", "Sahin", 20, "Erkek"),
    Ogrenci("Kadirhan","Simav",21,"Erkek"),
    Ogrenci("Ela", "Sahin", 20, "Erkek"),
    Ogrenci("Fatma","Simav",21,"Erkek"),
    Ogrenci("Sako", "Sahin", 20, "Erkek"),
    Ogrenci("Bako","Simav",21,"Erkek")
  ];
  final Set<Ogrenci> sevdiklerim={};
  void sev(Ogrenci ogrenci,bool seviyorMuyum){
      if(seviyorMuyum){
        sevdiklerim.add(ogrenci);
      }else{
        sevdiklerim.remove(ogrenci);
      }
      notifyListeners();
  }
  bool seviyorMuyum(Ogrenci ogrenci){
    return sevdiklerim.contains(ogrenci);
  }

}

final ogrenciProvider=ChangeNotifierProvider((ref){
  return ogrencilerRepo();
});



