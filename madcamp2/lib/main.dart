import 'package:flutter/material.dart';
// import 'package:madcamp2/pages/chat_page.dart';

import 'pages/tab_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/profile_page.dart';
import 'pages/home_page.dart';



// Widget _defaultHome = const LoginPage();
// Widget _defaultHome = ChatScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      //home: const LoginPage(),

      routes: {
        // '/': (context) => _defaultHome,
        '/tab': (context) => const TabPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
      },

    );
  }
}
