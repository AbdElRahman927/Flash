import 'package:flutter/material.dart';
import 'package:flash/screens/welcome_screen.dart';
import 'package:flash/screens/login_screen.dart';
import 'package:flash/screens/registration_screen.dart';
import 'package:flash/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey:"AIzaSyBJTLpKN62RNBuHIVn3qOxD5XbDWu1WLrI",
          appId: "1:736348221802:android:97f1b5a192edfac95eb513",
          messagingSenderId: "736348221802	",
          projectId: "flash-chat-f037c"));

  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          ChatScreen.id: (context) => const ChatScreen(),
        });
  }
}
