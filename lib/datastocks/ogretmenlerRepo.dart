import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/dataService/data_service.dart';
import 'package:googleflutterapp/model/ogretmen.dart';

class ogretmenlerRepo extends ChangeNotifier{
  final dataService;
  ogretmenlerRepo(this.dataService);
  List<Ogretmen> ogretmenler=[
    Ogretmen("Batuhan", "Sahin", 20, "Erkek"),
    Ogretmen("Kadirhan","Simav",21,"Erkek")
  ];
    download() async {
    Ogretmen ogretmen=await dataService.ogretmenIndir();
    ogretmenler.add(ogretmen);
    notifyListeners();
  }
  Future<List<Ogretmen>> allOgretmen() async {
    return await dataService.ogretmenleriIndir();
  }
}

final ogretmenProvider=ChangeNotifierProvider((ref){
  final dataProvider=ref.watch(dataServiceProvider);
  return ogretmenlerRepo(dataProvider);
});
final ogretmenFutureProvider=FutureProvider((ref){
  return ref.watch(ogretmenProvider).allOgretmen();
});
