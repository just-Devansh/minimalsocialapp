import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minimalsocialapp/auth/auth.dart';
import 'package:minimalsocialapp/auth/login_or_register.dart';
import 'package:minimalsocialapp/firebase_options.dart';
import 'package:minimalsocialapp/pages/profile_page.dart';
import 'package:minimalsocialapp/pages/users_page.dart';
import 'package:minimalsocialapp/theme/dark_mode.dart';
import 'package:minimalsocialapp/theme/light_mode.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/login_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/users_page': (context) => const UsersPage(),
      },
    );
  }
}
