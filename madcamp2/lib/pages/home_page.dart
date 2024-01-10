import 'package:flutter/material.dart';
import 'package:madcamp2/pages/ai_page.dart';
import 'package:madcamp2/server/network.dart';
import 'package:madcamp2/utils/user.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  Network network = Network();
  AIPage aiPage = AIPage();

  List<dynamic> youtubeList = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    var youtubes = await network.getAllYoutube();
    setState(() {
      youtubeList = youtubes['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Youtube',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: youtubeList.length,
        itemBuilder: (BuildContext context, int index) {
          // Use GestureDetector or InkWell for tap functionality
          return GestureDetector(
            onTap: () {
              // Handle tap action here, for example, open a link
              String link = youtubeList[index]['url'];
              // Navigate to the link or perform other actions
              launch('$link', forceSafariVC: true);
              User.setUrl(link);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5.0,
              margin: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                color: Colors.white,
                child: Center(child: Text('${youtubeList[index]['text']}')),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
