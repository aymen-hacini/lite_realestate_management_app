import 'package:agence/components/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../homepage/components/notecard.dart';

class Besoins extends StatefulWidget {
  const Besoins({super.key});

  @override
  State<Besoins> createState() => _BesoinsState();
}

class _BesoinsState extends State<Besoins> {
  var besoinsref = FirebaseFirestore.instance.collection('besoins');
  var user = FirebaseAuth.instance.currentUser;
  String title = "", desc = "";
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  addnote() async {
    var formdata = formstate.currentState;

    if (formdata!.validate()) {
      Navigator.of(context).pop();
      showloading(context);
      formdata.save();
      await FirebaseFirestore.instance
          .collection('besoins')
          .add({'title': title, 'desc': desc, 'userid': user!.uid});
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFEF9A7),
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                context: context,
                builder: (context) {
                  return SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: Form(
                          key: formstate,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addnoteInput(
                                text: 'Title',
                                saved: (val) {
                                  title = val!;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              addnoteInput(
                                text: 'Description',
                                max: 10,
                                saved: (val) {
                                  desc = val!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel')),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50))),
                                      onPressed: () async {
                                        await addnote();
                                      },
                                      child: const Text('Save')),
                                ],
                              )
                            ],
                          )),
                    ),
                  );
                });
          },
          child: const Icon(
            Icons.add,
            color: Color(0xFF060400),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "Excellence",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
          ),
        ),
        body: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            padding: const EdgeInsets.only(left: 20, right: 20),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF060400), Color(0xFFD61C4E)],
              ),
            ),
            child: StreamBuilder(
              stream:
                  besoinsref.where('userid', isEqualTo: user!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) async {
                          await besoinsref
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        },
                        key: UniqueKey(),
                        child: streamnotecard(
                          docid: snapshot.data!.docs[index].id,
                          index: index,
                          snapshot: snapshot,
                        ),
                      );
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const Text('Loading');
              },
            )));
  }
}

class addnoteInput extends StatelessWidget {
  const addnoteInput(
      {super.key,
      this.saved,
      required this.text,
      this.max = 1,
      this.initialvalue});
  final void Function(String?)? saved;
  final String? initialvalue;
  final String text;
  final int max;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: initialvalue,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Do not leave this field empty';
          }
          return null;
        },
        style: const TextStyle(color: Colors.white),
        maxLines: max,
        onSaved: saved,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFFFAC213))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFFD61C4E))),
            hintText: text,
            hintStyle: const TextStyle(color: Colors.white)));
  }
}
