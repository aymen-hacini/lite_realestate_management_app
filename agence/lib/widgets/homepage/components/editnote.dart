import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/alert.dart';
import '../homepage.dart';

class editnote extends StatefulWidget {
  const editnote({super.key, this.docid, this.notes});
  final String? docid;
  final notes;
  @override
  State<editnote> createState() => _editnoteState();
}

class _editnoteState extends State<editnote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  var notesref = FirebaseFirestore.instance.collection('notes');
  var user = FirebaseAuth.instance.currentUser;
  String title = '', desc = '';
  editnote() async {
    var formdata = formstate.currentState;

    if (formdata!.validate()) {
      showloading(context);
      //Navigator.of(context).pop();
      formdata.save();
      await notesref
          .doc(widget.docid)
          .update({'title': title, 'desc': desc, 'userid': user!.uid});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Edit Note",
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
        child: SingleChildScrollView(
          child: SizedBox(
            //margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Form(
                key: formstate,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addnoteInput(
                      initialvalue: widget.notes['title'],
                      text: 'title',
                      saved: (val) {
                        title = val!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    addnoteInput(
                      initialvalue: widget.notes['desc'],
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
                                    borderRadius: BorderRadius.circular(50))),
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
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () async {
                              await editnote();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save')),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
