import 'package:flutter/material.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(title: const Text('설정'),),
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
                Text('홈 스크린'),
                Text('채팅 스크린'),
                ProfilePage(),
              ],
            ),
          )
      ),

    );
  }


}
