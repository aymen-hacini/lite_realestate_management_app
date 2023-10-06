import 'package:agence/widgets/auth/signup.dart';
import 'package:agence/widgets/auth/login.dart';
import 'package:agence/widgets/homepage/homepage.dart';
import 'package:agence/widgets/selection/sections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agence/widgets/besoins/besoins.dart';




bool islogin = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    islogin = true;
  } else {
    islogin = false;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Ubuntu'),
      debugShowCheckedModeBanner: false,
      title: 'Agence Excellence',
      home: islogin == false ? const login() : const sections(),
      routes: {
        'login': (context) => const login(),
        'signup': (context) => const signup(),
        'homepage': (context) => const homepage(),
        'sections': (context) => const sections(),
        'besoins':(context) => const Besoins(),
      },
    );
  }
}
