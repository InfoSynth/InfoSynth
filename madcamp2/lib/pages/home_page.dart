import 'package:flutter/material.dart';
import 'package:madcamp2/server/network.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  Network network = Network();

  List<dynamic> newList = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    var news = await network.getNews();
    setState(() {
      newList = news['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: newList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.white,
          child: Center(child: Text('${newList[index]['title']}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
