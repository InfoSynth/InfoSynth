import 'package:flutter/material.dart';
import 'package:madcamp2/pages/home_page.dart';
import 'ai_page.dart';
import 'profile_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dating App'),
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
          length: 3,
          child: Scaffold(
            bottomNavigationBar: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'home',
              ),
              Tab(
                icon: Icon(Icons.chat),
                text: 'chat',
              ),
              Tab(
                icon: Icon(Icons.people),
                text: 'my',
              )
            ]),
            body: TabBarView(
              children: [
                HomePage(),
                AIPage(),
                ProfilePage(),
              ],
            ),
          )),
    );
  }
}
