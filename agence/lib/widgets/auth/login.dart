import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../components/alert.dart';

bool isloading = true;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String email = '', pass = '';
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signin() async {
    showloading(context);
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: 'error',
              dialogType: DialogType.error,
              showCloseIcon: true,
              body: const Text(
                'No user found for that email.',
              )).show();
          print('nouser');
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: 'error',
              dialogType: DialogType.error,
              showCloseIcon: true,
              body: const Text(
                'Wrong password provided for that user.',
              )).show();
        }
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: double.infinity,
        padding: const EdgeInsets.only(
          top: 170,
          left: 20,
          right: 20,
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
                      email = val!;
                    },
                    validator: (val) {
                      if (val!.length > 30) {
                        return 'email needs to be less than 30 letters';
                      }
                      return null;
                    },
                    text: 'Email',
                    icon: Icons.account_circle_outlined,
                    obscure: false,
                  ),
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
                  SignIn_button(),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFD61C4E),
                  ),
                  const Center(
                      child: Text('Or Sign In with',
                          style: TextStyle(
                              fontSize: 15, color: Color(0xFFD61C4E)))),
                  const SizedBox(
                    height: 15,
                  ),
                  othersigninMethods(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row othersigninMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
            onTap: () async {
              showloading(context);
              var cred = await signInWithGoogle();
              if (cred.user != null) {
                Navigator.of(context).pushReplacementNamed('sections');
              }
            },
            child: Image.asset('images/search.png')),
      ],
    );
  }

  Padding SignIn_button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0xFFD61C4E)),
          onPressed: () async {
            var user = await signin();
            if (user != null) {
              Navigator.of(context).pushReplacementNamed('sections');
            } else {
              Navigator.of(context).pop();
              AwesomeDialog(
                  context: context,
                  title: 'error',
                  dialogType: DialogType.error,
                  showCloseIcon: true,
                  body: const Text(
                    'Wrong Email or Password, Sign in failed.',
                  )).show();
            }
          },
          child: const Text(
            'SIGN IN',
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
      const Text("if you don't have an account, ",
          style: TextStyle(fontSize: 14)),
      InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('signup');
        },
        child: const Text('Register Here',
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
    this.validator,
    this.saved,
  });
  final String? Function(String?)? validator;
  final void Function(String?)? saved;
  final String text;
  final IconData icon;
  final bool obscure;
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
