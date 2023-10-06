import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class sections extends StatelessWidget {
  const sections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Drawer(
            child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 173, 2, 2),
                      child: Text(
                        '${user!.email?[0].toUpperCase()}',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w400),
                      )),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0xFF060400), Color(0xFFD61C4E)],
                  )),
                  accountName: const Text("Excellence Agent"),
                  accountEmail: Text("${user?.email}")),
            ),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('login');
              },
              leading: const Icon(Icons.exit_to_app_rounded),
              title: const Text(
                'Sign out',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              onTap: () {
                AwesomeDialog(
                    transitionAnimationDuration:
                        const Duration(milliseconds: 500),
                    barrierColor: const Color.fromARGB(180, 0, 0, 0),
                    dialogBorderRadius: BorderRadius.circular(20),
                    btnOkColor: Colors.red,
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.scale,
                    title: 'About',
                    desc: 'App version 1.0.0\nDevelopped by Aymen Hacini.',
                    btnOkOnPress: () => Navigator.of(context).pop()).show();
              },
              leading: const Icon(Icons.info),
              title: const Text(
                'About',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            )
          ],
        )),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('homepage');
                },
                child: const sectionCard(
                  text: 'Disponible',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('besoins');
                },
                child: const Center(
                  child: sectionCard(
                    text: 'Besoins',
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class sectionCard extends StatelessWidget {
  const sectionCard({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.5,
      height: MediaQuery.sizeOf(context).height * 0.15,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        gradient: LinearGradient(
          begin: const Alignment(0.00, -1.00),
          end: const Alignment(0, 1),
          colors: [const Color(0xFFD61C4E), Colors.black.withOpacity(0.75)],
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
