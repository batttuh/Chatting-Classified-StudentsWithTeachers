
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/datastocks/ogrencilerRepo.dart';
import 'package:googleflutterapp/pages/ogrenciler.dart';
import 'package:googleflutterapp/pages/ogretmenler.dart';
import 'package:googleflutterapp/utilities/google_services.dart';

import 'datastocks/mesajlarRepo.dart';
import 'datastocks/ogretmenlerRepo.dart';
import 'pages/mesajlar.dart';

void main() {
  runApp( ProviderScope(
    child: MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SliderPage(),
    );
  }
}
class SliderPage extends StatefulWidget {
  const SliderPage({ Key? key }) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  String? email;
  final _formKey=GlobalKey<FormState>();
   bool isSigned=false;
  String? password;
  bool isFirebaseStarted=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeFirebase();
  }
    initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      isFirebaseStarted=true;
    });
    
     if(FirebaseAuth.instance.currentUser!=null){
      await FirebaseFirestore.instance.collection("kullanici").doc(FirebaseAuth.instance.currentUser!.uid).set({
                      "giris-tarihi": FieldValue.serverTimestamp(),
                      "giris-yaptimi": true,
                  });
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return MyHomePage();
      },)
      );
    }
    }

  @override
  Widget build(BuildContext context) {
    return false? CircularProgressIndicator(): Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key:_formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "E-Mail"
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                              }
                              return null;
                        },
                        onChanged: (value){
                          setState(() {
                            email=value;
                          });
                          
                        },
                        ),
                        TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                           decoration: const InputDecoration(
                            hintText: "Password Please"
                            ),
                            validator: (value) {
                               if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                              }
                            
                              return null;
                            },
                             onChanged: (value){
                                 setState(() {
                                 password=value;
                                 });
                             },
                        ),
                  ],
                ),
              ),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
                    children: [
                      ElevatedButton(onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                               await loginUser();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  
                                  const SnackBar(content: Text('Processing Data')),
                                );
                              }
                              else{
                                print("Form key");
                              }
                          
                      }, child: Text("Login")),
                      ElevatedButton(onPressed: () async {
                           if (_formKey.currentState!.validate()) {
                                await userRegister();
                                ScaffoldMessenger.of(context).showSnackBar( 
                                  const SnackBar(content: Text('Processing Data')),
                                );
                              }
                              else{
                                print("Form key");
                              }
                       
                      }, child: Text("Sign in")),   
                    ],
                  ),
                   
              ElevatedButton(onPressed: () async {
                await signInWithGoogle();
                if(FirebaseAuth.instance.currentUser!=null){
                await  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
                     "giris-tarihi": FieldValue.serverTimestamp(),
                      "giris-yaptimi": true,
                  });
                   Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const MyHomePage();
                  },)
                );
                  
                }
                 
              },child: Text("Login with Google"),),
              Visibility(visible:isSigned, child: Text("Succesfully Signed")),
            ],
          ),
        ),
      )
    );
  }

  Future<void> userRegister() async {

    try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!
        );
        setState(() {
          isSigned=true;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print("14");
        print(e);
      }
  }

  loginUser() async {
          try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email!,
            password: password!
          );
                await  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
                      "giris-tarihi": FieldValue.serverTimestamp(),
                      "giris-yaptimi": true,
                  });
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const MyHomePage();
                  },)
            );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
        }
  
  }
class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final ogrencilerProvider=ref.watch(ogrenciProvider);
    final ogretmenProv=ref.watch(ogretmenProvider);
    

    return Scaffold(
      appBar: AppBar(
        title: Text("Deneme"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menü'),
              ),
            ),
            ListTile(
              title: Text('${ogrencilerProvider.ogrenciler.length} Öğrenciler'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('${ogretmenProv.ogretmenler.length} Öğretmen'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text("${ref.watch(yeniMesajSayisiProvider)}Mesajlar"),
              onTap: (){

              },
            ),
            ListTile(
              title: Center(child: const Text("Cıkıs yap")),
              onTap: () async {
                final UID = FirebaseAuth.instance.currentUser?.uid;
                bool response =await signOutWithGoogle();
                  if(response){
                    FirebaseFirestore.instance.collection("users").doc(UID).update({
                      "giris-yaptimi":false,
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: ((context) {
                        return SliderPage();
                      })
                      )
                    );
                  }
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
              AnimatedPadding(
                duration: Duration(seconds: 1),
                padding: false ? EdgeInsets.only(left: 10):EdgeInsets.only(),
                curve:Curves.bounceInOut,
                child: TextButton(
                  onPressed:
                (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>mesajlar())
                  );
                },
                  child: Column(
                  children: [
                    Text("${ref.watch(yeniMesajSayisiProvider)} Mesajlar sana ${FirebaseAuth.instance.currentUser?.email}"),
                  ],
                ),
                ),
              ),
            TextButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>ogrenciler())
              );
            }, child:
           Text('${ogrencilerProvider.ogrenciler.length} Öğrenciler')),
            TextButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>ogretmenler())
              );
            },
                child: Text('${ogretmenProv.ogretmenler.length} Öğretmen'))
          ],
        ),
      ),
    );
  }
}



