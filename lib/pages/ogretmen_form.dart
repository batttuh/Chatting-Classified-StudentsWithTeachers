import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/dataService/data_service.dart';
import 'package:googleflutterapp/model/ogretmen.dart';


class OgretmenForm extends ConsumerStatefulWidget {
  OgretmenForm({Key? key}) : super(key: key);

  @override
  _OgretmenFormState createState() => _OgretmenFormState();
}

class _OgretmenFormState extends ConsumerState<OgretmenForm> {
  final Map<String, dynamic> girilen = {};
  bool isSave=false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Ad"),
                  ),
                  validator: (valid) {
                    if (valid == null) {
                      return "Ad girmeniz gerek";
                    }
                  },
                  onSaved: (value) {
                    girilen["ad"] = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Soyad")
                  ),
                  validator: (valid) {
                    if (valid?.isNotEmpty != true) {
                      return "Soyadı Girmeniz Gerek";
                    }
                  },
                  onSaved: (value) {
                    girilen["soyad"] = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Yaş"),
                  ),
                  validator: (valid) {
                    if (valid==null||valid.isNotEmpty != true) {
                      return "Yas girmeniz gerek";
                    }
                    if(int.tryParse(valid)==null){
                      return "Sayı girmeniz gerek";
                    }
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    girilen["yas"] = int.parse(value!);
                  },
                ),
                DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(
                      child: Text("Erkek"),
                      value: "Erkek",
                    ),
                    DropdownMenuItem(
                      child: Text("Kadın"),
                      value: "Kadın",
                    ),

                  ],
                  value: girilen["cinsiyet"],
                  onChanged: (value) {
                    setState(() {
                      girilen["cinsiyet"] = value;
                    });
                  },
                  validator: (validate) {
                    if (validate == null) {
                      return "Cinsiyet giriniz";
                    }
                  },
                ),
                isSave? const Center(child: CircularProgressIndicator()):ElevatedButton(
                    onPressed:() async {
                      final formState=_formKey.currentState;
                      if(formState==null){
                      return;
                      }else if(formState.validate()!=null){
                          formState.save();
                          print(girilen);
                      }

                      try{
                        setState(() {
                          isSave=true;
                        });
                        await ref.read(dataServiceProvider).ogretmenYukle(Ogretmen.fromMap(girilen));
                       return Navigator.of(context).pop(true);
                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                      finally{
                        setState(() {
                          isSave=false;
                        });
                      }

                    },

                    child: const Text("Ekle"))
              ],

            ),

          ),
        ),

      ),


    );
  }
}
