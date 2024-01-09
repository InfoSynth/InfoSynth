import 'package:flutter/material.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getNews();
  }


  getData() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('홈 스크린'),
    );
  }


}
