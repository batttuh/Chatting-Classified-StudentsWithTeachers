import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleflutterapp/datastocks/ogretmenlerRepo.dart';

import 'ogretmen_form.dart';

class ogretmenler extends ConsumerWidget {
  const ogretmenler({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isReturned=false;
    final ogretmenProv=ref.watch(ogretmenProvider);
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           PhysicalModel(
              color: Colors.white,
              elevation: 20,

              child: Stack(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20,),
                      child: Text("Öğretmenler Listesi"),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                      child: downloadTeacher()
    )
    ],
    )),
    Expanded(
    child: Container(
    child:RefreshIndicator(
      onRefresh: () async {
        ref.refresh(ogretmenFutureProvider);
      },
      child: ref.watch(ogretmenFutureProvider).when(
        data: (data)=>ListView.separated(
      padding: EdgeInsets.all(26),
      itemBuilder: (context, index) {
      return ListTile(
      title: Text(data[index].ad),
      );
      },
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(),
      ), 
      error: (error, stackTrace) {
        return const Text("dsad");
      }
      , 
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },),
    ) 
    ),
    ),
          
    ],
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final Future<bool?> check=Navigator.of(context).push<bool>(MaterialPageRoute(
            builder: (context) {
              return OgretmenForm();
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
    }
  }

class downloadTeacher extends StatefulWidget {
  const downloadTeacher({
    Key? key,
  }) : super(key: key);

  @override
  State<downloadTeacher> createState() => _downloadTeacherState();
}

class _downloadTeacherState extends State<downloadTeacher> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder:(context, ref, child) {
        return isLoading? CircularProgressIndicator():IconButton(
          icon: Icon(Icons.download),
          onPressed: () async {
            try{
            setState(() {
              isLoading=true;
            });
            await ref.read(ogretmenProvider).download();
            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            }
            finally{
            setState(() {
              isLoading=false;
            });
            }

          }
          );
      }
    );
  }
}
