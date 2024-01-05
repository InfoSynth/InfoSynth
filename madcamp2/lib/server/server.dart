import 'package:flutter/material.dart';
import 'package:madcamp2/server/network.dart';

class MyView extends StatefulWidget {
  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  //사용할 변수 미리 선언
  late String userName = '';
  late String userEmail = '';

  @override
  void initState() {
    super.initState();
    //state 진입시 api 데이터 파싱.
    getTestData();
  }

  getTestData() async {
    //url을 받아 데이터를 파싱하는 network 메소드 사용. 미리 만들어둠.
    //mysql db에서 유저 데이터를 받아오는 express api 호출
    Network network = Network();

    var jsonData = await network.getJsonData();
    Map<String, String> newMember = {
      "user_name": "name_6",
      "user_email": "user_email",
      "account_id": "account_id",
      "account_password": "account_password"
    };
    network.addMembers(newMember);

    setState(() {
      userName = jsonData[0]['user_name'];
      userEmail = jsonData[0]['user_email'];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.greenAccent,
        child: Center(
          child: Column(
            children: [
              Text('${userName}'),
              Text('${userEmail}'),
            ],
          ),
        ),
      ),
    );
  }
}
