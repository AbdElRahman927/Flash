import 'package:flash/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash/components/flashbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'log';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'flash',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                  
                      kTextfeildDec.copyWith(hintText: 'Enter your email')),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      kTextfeildDec.copyWith(hintText: 'Enter your password')),
              const SizedBox(
                height: 24.0,
              ),
              flash_button(
                colorr: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async {
                  setState(() {
                    showspinner = true;
                  });

                  try {
                    // ignore: unused_local_variable
                    final userr = await _auth.signInWithEmailAndPassword(
                        email: email.toString(), password: password.toString());

                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, ChatScreen.id);
                    setState(() {
                      showspinner = false;
                    });
                  } catch (e) {
                    // ignore: avoid_print
                    print('');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
