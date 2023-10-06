import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editnote.dart';

final notesref = FirebaseFirestore.instance.collection('notes');
final user = FirebaseAuth.instance.currentUser;

class streamnotecard extends StatelessWidget {
  const streamnotecard(
      {super.key, required this.snapshot, required this.index, this.docid});
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int index;
  final String? docid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return editnote(
            docid: docid,
            notes: snapshot.data!.docs[index],
          );
        }));
      },
      onLongPress: () {
        AwesomeDialog(
            transitionAnimationDuration: const Duration(milliseconds: 500),
            barrierColor: const Color.fromARGB(180, 0, 0, 0),
            dialogBorderRadius: BorderRadius.circular(20),
            btnOkColor: Colors.red,
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.bottomSlide,
            title: 'Delete',
            desc: 'Do you want to delete this note ?',
            btnOkOnPress: () async {
              await notesref.doc(snapshot.data!.docs[index].id).delete();
              Navigator.of(context).pushReplacementNamed('homepage');
            },
            btnCancelOnPress: () {
              Navigator.of(context).pushReplacementNamed('homepage');
            }).show();
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 20),
        width: MediaQuery.sizeOf(context).width,
        height: 180,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.00, -1.00),
            end: const Alignment(0, 1),
            colors: [const Color(0xFFD61C4E), Colors.black.withOpacity(0.75)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              "${snapshot.data!.docs[index].data()['title']}",
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
            child: Text(
              maxLines: 4,
              "${snapshot.data!.docs[index].data()['desc']}",
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
              overflow: TextOverflow.fade,
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20, right: 20),
                child: Text(
                  '12.2.2022',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
