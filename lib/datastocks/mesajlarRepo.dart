
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/main.dart';
import 'package:googleflutterapp/model/mesaj.dart';

class MesajlarRepository extends ChangeNotifier{
  final List<Mesaj> mesajlar=[
    Mesaj("Merhaba","Ali",DateTime.now().subtract(const Duration(minutes: 3))),
    Mesaj("Orada Misin","Ali",DateTime.now().subtract(const Duration(minutes: 2))),
    Mesaj("Evet","Ayse",DateTime.now().subtract(const Duration(minutes: 1))),
  ];

  void mesajEkle(String mesaj,String gonderen,DateTime time){
    mesajlar.add(Mesaj(mesaj,gonderen,time));
    notifyListeners();
  }

}
final mesajlarProvider=ChangeNotifierProvider((ref){
  return MesajlarRepository();
}
);
class YeniMesajSayisi extends StateNotifier<int>{
  YeniMesajSayisi(int state):super(state);
  void sifirla(){
    state=0;
  }
}
final yeniMesajSayisiProvider=StateNotifierProvider<YeniMesajSayisi,int>((ref){
  return YeniMesajSayisi(3);
});

