import 'package:agence/components/alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  String username = "", pass = "", email = "";
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  SignupUser() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showloading(context);
        final UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: 'error',
                  dialogType: DialogType.error,
                  showCloseIcon: true,
                  body: const Text('The password provided is too weak.'))
              .show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
                  context: context,
                  title: 'error',
                  dialogType: DialogType.error,
                  showCloseIcon: true,
                  body:
                      const Text('The account already exists for that email.'))
              .show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(
          top: 170,
          left: 60,
          right: 60,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [
              Color(0xFFFAC213),
              Color(0xE8FEF9A7),
              Color(0xE2FEF9A7),
              Color(0xFFFAC213)
            ],
          ),
        ),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                children: [
                  Container(
                      child: const Icon(
                    Icons.dangerous,
                    size: 100,
                  )),
                  inputbox(
                    saved: (val) {
                      username = val!;
                    },
                    validator: (val) {
                      if (val!.length > 25) {
                        return 'username needs to be lower than 25 letters';
                      }
                      return null;
                    },
                    text: 'Username',
                    icon: Icons.account_circle_outlined,
                    obscure: false,
                  ),
                  inputbox(
                      saved: (val) {
                        email = val!;
                      },
                      validator: (val) {
                        if (val!.length > 25) {
                          return 'email needs to be lower than 25 letters';
                        }
                        return null;
                      },
                      text: 'Email',
                      icon: Icons.email,
                      obscure: false),
                  inputbox(
                    saved: (val) {
                      pass = val!;
                    },
                    validator: (val) {
                      if (val!.length < 4) {
                        return 'password needs to be higher than 4 letters';
                      }
                      return null;
                    },
                    text: 'Password',
                    icon: Icons.lock,
                    obscure: true,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Alternative_signup(),
                  SignUp_button(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding SignUp_button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0xFFD61C4E)),
          onPressed: () async {
            var response = await SignupUser();
            if (response != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .add({"username": username, "email": email});
              Navigator.of(context).pushReplacementNamed('sections');
            } else {
              print('signup failed');
            }
          },
          child: const Text(
            'SIGN Up',
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFEF9A7),
                fontWeight: FontWeight.bold),
          )),
    );
  }

  Center Alternative_signup() {
    return Center(
        child: Row(children: [
      const Text("if you already have an account, ",
          style: TextStyle(fontSize: 12)),
      InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('login');
        },
        child: const Text('Sign In',
            style: TextStyle(fontSize: 14, color: Color(0xFFD61C4E))),
      )
    ]));
  }
}

class inputbox extends StatelessWidget {
  const inputbox({
    super.key,
    required this.text,
    required this.icon,
    required this.obscure,
    this.saved,
    this.validator,
  });

  final String text;
  final IconData icon;
  final bool obscure;
  final void Function(String?)? saved;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onSaved: saved,
          validator: validator,
          obscureText: obscure,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFFFAC213))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFFD61C4E))),
              hintText: text,
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFD61C4E),
              ))),
    );
  }
}
