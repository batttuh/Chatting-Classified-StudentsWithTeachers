import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/datastocks/mesajlarRepo.dart';

class mesajlar extends ConsumerStatefulWidget {
  const mesajlar({Key? key}) : super(key: key);

  @override
  _mesajlarState createState() => _mesajlarState();
}

class _mesajlarState extends ConsumerState<mesajlar> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => ref.read(yeniMesajSayisiProvider.notifier).sifirla());

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final inputController=TextEditingController();
    final mesajlarRepo=ref.watch(mesajlarProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Mesajlar"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(

              reverse: true,
              itemCount: mesajlarRepo.mesajlar.length,
                  itemBuilder: (context, index) {

                    bool? isThisAli;
                    if(mesajlarRepo.mesajlar[mesajlarRepo.mesajlar.length-index-1].gonderen=="Ali"){
                      isThisAli=true;

                    }else{
                      isThisAli=false;
                    }


                    return  Align(
                      alignment: isThisAli? Alignment.centerRight:Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                              borderRadius: const BorderRadius.all(Radius.circular(15))

                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                            child: Text(
                                mesajlarRepo.mesajlar[mesajlarRepo.mesajlar.length-index-1].yazi
                            ),
                          ),
                        ),
                      ),
                    );
                  },

                ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(
                    Radius.circular(0)

                )
            ),
            child: Row(
              children: [
                Expanded(
                  child: DecoratedBox(

                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                          Radius.circular(25)

                      )
                    ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: inputController,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    ref.read(mesajlarProvider).mesajEkle(inputController.text, "Ali", DateTime.now().subtract(const Duration(minutes: 0)));
                    inputController.text="";
                  },
                      child: Text("Gönder")),
                ),
              ],
            ),
          )
        ],
      ),

      );
  }
}
