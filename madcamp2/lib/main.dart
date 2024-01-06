import 'package:flutter/material.dart';
import 'package:madcamp2/pages/chat_page.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';

// Widget _defaultHome = const LoginPage();
Widget _defaultHome = ChatScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get result of the login function.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const LoginPage(),
      routes: {
        '/': (context) => _defaultHome,
        // '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
