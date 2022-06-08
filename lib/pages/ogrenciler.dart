import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/datastocks/ogrencilerRepo.dart';

class ogrenciler extends ConsumerWidget {
  const ogrenciler({Key? key}) : super(key: key);


  Widget build(BuildContext context,WidgetRef ref) {
    final ogrenci=ref.watch(ogrenciProvider);
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PhysicalModel(
            color: Colors.white,
              elevation: 20,

              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20,),
                  child: Text("Öğrenciler Listesi"),
                ),
              )),
          Expanded(
            child: Container(
              child: ListView.separated(
                padding: EdgeInsets.all(26),
                itemBuilder: (context, index) {
                 return ListTile(
                   trailing: IconButton(

                     onPressed: (){
                       ref.read(ogrenciProvider).sev(ogrenci.ogrenciler[index], !ogrenci.seviyorMuyum(ogrenci.ogrenciler[index]));
                     },
                     icon: ogrenci.seviyorMuyum(ogrenci.ogrenciler[index]) ? Icon(Icons.favorite) :Icon(Icons.favorite_border),
                   ),
                   leading: Icon(Icons.add),
                   title: Text(ogrenci.ogrenciler[index].name),
                  );
                },
                itemCount: ogrenci.ogrenciler.length,
                separatorBuilder: (context, index) => Divider(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
