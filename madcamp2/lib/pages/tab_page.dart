import 'package:flutter/material.dart';
import 'package:madcamp2/pages/home_page.dart';

import 'ai_page.dart';
import 'profile_page.dart';

class TabPage extends StatefulWidget {
  final int initialTabIndex;

  const TabPage({super.key, this.initialTabIndex = 0});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: widget.initialTabIndex, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('InfoSynth'),
      //   automaticallyImplyLeading: false,
      // ),
      body: DefaultTabController(
          length: 3,
          child: Scaffold(
            bottomNavigationBar: TabBar(controller: _tabController, tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'home',
              ),
              Tab(
                icon: Icon(Icons.search),
                text: 'search',
              ),
              Tab(
                icon: Icon(Icons.people),
                text: 'my',
              )
            ]),
            body: TabBarView(
              controller: _tabController,
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
