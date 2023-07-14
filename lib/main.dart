import 'package:flash_app/screens/chat_screen.dart';
import 'package:flash_app/screens/login_screen.dart';
import 'package:flash_app/screens/registration_screen.dart';
import 'package:flash_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product UIs',
      theme: ThemeData(
        // backgroundColor: const Color.fromARGB(255, 43, 41, 41),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: WelcomeScreen.ID,
      //home: product_one(),
      routes: {
        WelcomeScreen.ID: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),

        //'/home2': ( context) => home(),

        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      //product_one(),
    );
  }
}
