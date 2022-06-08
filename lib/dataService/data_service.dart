
  import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:googleflutterapp/model/ogretmen.dart';
import 'package:googleflutterapp/pages/ogretmenler.dart';
  import 'package:http/http.dart' as http;
class DataService {
  final baseUrl="https://6235c9b1eb166c26eb2bf66b.mockapi.io/ogretmenler";
   Future<Ogretmen> ogretmenIndir() async {
     final response= await http.get(Uri.parse("${baseUrl}/1"));
     if (response.statusCode == 200) {
       return Ogretmen.fromMap(jsonDecode(response.body));
     } else {
       throw Exception('Failed to load Name');
     }
   }
   Future<void> ogretmenYukle(Ogretmen ogretmen) async {
     CollectionReference users = await FirebaseFirestore.instance.collection('ogretmen');
     users.add(ogretmen.toMap());
     /*
     final response=await http.post(
       Uri.parse('${baseUrl}'),
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
       body: jsonEncode(ogretmen.toMap()),
     );
     if (response.statusCode == 201) {
       return ;
     } else {

       throw Exception('Failed to load Ogretmen');
     }
     */

   }
   Future<List<Ogretmen>> ogretmenleriIndir() async {
     final querySnapshot=await FirebaseFirestore.instance.collection('ogretmen').get();
     return querySnapshot.docs.map((e) => Ogretmen.fromMap(e.data())).toList();
   /*
     final response= await http.get(Uri.parse("${baseUrl}"));
     if (response.statusCode == 200) {
       final l=jsonDecode(response.body);
       return l.map<Ogretmen>((e)=>Ogretmen.fromMap(e)).toList();
     } else {
       throw Exception('Failed to load Name');
     }
     */
   }
   
 }
  final dataServiceProvider=Provider((ref){
    return DataService();
  });
