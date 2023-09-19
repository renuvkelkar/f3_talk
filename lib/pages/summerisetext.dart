import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3_talk/pages/TalkSummery.dart';
import 'package:flutter/material.dart';

import '../model/data.dart';

class SummersiseText extends StatefulWidget {

   SummersiseText( {Key? key}) : super(key: key);

  @override
  State<SummersiseText> createState() => _SummersiseTextState();
}

class _SummersiseTextState extends State<SummersiseText> {
  final ref = FirebaseFirestore.instance
      .collection('summarise')

      .withConverter<DataModel>(
    fromFirestore: (snapshot, _) => DataModel.fromJson(
      snapshot.data()!,
    ),
    toFirestore: (model, _) => model.toJson(),
  );
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => TalkSummery()));
          },
          child: const Icon(Icons.add,size: 40,),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,

      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("Summarise Talk"),
        centerTitle: true,
      ),
      body:   SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/talk.png',height: 200,width: 200,fit: BoxFit.contain,),
            StreamBuilder(
              stream: ref.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs.length;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Column(
                                children: [
                          Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: ListTile(
                              title:
                              Text(
                                snapshot.data!.docs[index]['speakerName'].toString(),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 243, 243, 248),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data?.docs[index]['summary'].toString()??"loading",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 247, 245, 245),
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                onPressed: () async {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text('link Copied to your clipboard !'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),



                              
                                ],
                              ),

                            ],
                          ),
                        );
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),

    );
  }
}
