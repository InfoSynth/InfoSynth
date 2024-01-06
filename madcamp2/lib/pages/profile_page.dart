import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:madcamp2/server/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum genderType { male, female }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late String userName = '';
  late String userEmail = '';
  late String userBirth = '';
  late genderType userGender = genderType.female;
  late String userPassword = '';

  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;

  @override
  void initState() {
    super.initState();
    //state 진입시 api 데이터 파싱.
    getTestData();
    getUserInfo();


  }

  getTestData() async {
    Network network = Network();
    var jsonData = await network.allMember();

    setState(() {
      userName = jsonData[0]['name'];
      userEmail = jsonData[0]['email'];
      userBirth = jsonData[0]['birth'];
      // userGender = jsonData[0]['gender'];
      userPassword = jsonData[0]['password'];
    });
  }
  getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    final email = prefs.getString('email') ?? '';

    setState(() {
      userName = username.toString();
      userEmail = email.toString();
    });
  }

  @override
  Widget build(BuildContext context) {

    final imageSize = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      appBar: AppBar(title: const Text('설정'),),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Center(
              child: Column(

                children: [
                  Icon(
                    Icons.account_circle,
                    size: imageSize,
                  ),
                  Text('${userName}'),
                  Text('${userEmail}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
