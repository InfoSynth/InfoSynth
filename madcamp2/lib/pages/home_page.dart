import 'package:flutter/material.dart';
import 'package:madcamp2/server/network.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  Network network = Network();
  // List<Map> newList = List<>();
  @override
  void initState() {
    super.initState();
    getNews();
  }


  getNews() async {
    var news = await network.getNews();
    setState(() {
      // newList = news['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('홈 스크린'),
    );
  }

}
