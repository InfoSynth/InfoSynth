import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  late String userBirth = '';
  late genderType userGender = genderType.female;
  late String userEmail = '';
  late String userPassword = '';

  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;

  final double coverHeight = 280;
  final double profileHeight = 144;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await getLoginInfo();
    await getDbData();
  }

  getDbData() async {
    Network network = Network();
    Map<String, String> check = {
      "email": userEmail,
    };
    var checked_data = await network.checkMemberByEmail(check);

    DateTime date = DateTime.parse(checked_data[0]['birth']);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    setState(() {
      userName = checked_data[0]['name'];
      userBirth = formattedDate;
      // userGender = checked_data['gender'];
      userEmail = checked_data[0]['email'];
      userPassword = checked_data[0]['password'];
    });
  }

  getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    setState(() {
      userEmail = email.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildCenter(),
          buildBottom(),
          SizedBox(height: 30),
          buildEditButton(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: Image.network(
        "https://source.unsplash.com/random",
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProfileImage() {
    return CircleAvatar(
      radius: profileHeight / 2 + 4,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
            "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8JUVCJUFBJUE4JUVCJThEJUI4fGVufDB8fDB8fHww"),
      ),
    );
  }

  Widget buildCenter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          SizedBox(height: 16),
          buildContent(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text('${userName}',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 2),
        Text('${userEmail}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
              height: 1.4,
            )),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialIcon(FontAwesomeIcons.instagram),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.threads),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.facebook),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.xTwitter),
          ],
        )
      ],
    );
  }

  Widget buildSocialIcon(IconData icon) {
    return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blue.shade100,
        child: Material(
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Icon(icon, size: 32),
            ),
          ),
        ));
  }

  Widget buildBottom() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          buildHashTag(),
        ],
      ),
    );
  }

  Widget buildHashTag() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Text('Interest',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 10),
            buildhashTagPlusButton(),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            buildHashTagItem('음악'),
            const SizedBox(width: 8),
            buildHashTagItem('주식'),
            const SizedBox(width: 8),
            buildHashTagItem('고양이'),
          ],
        ),
      ],
    );
  }

  Widget buildHashTagItem(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      child: Text(text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          )),
    );
  }

  Widget buildhashTagPlusButton() {
    return Container(
      width: 32,
      height: 32,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget buildEditButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/edit');
            },
            child: Text('정보 수정하기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   final imageSize = MediaQuery.of(context).size.width / 3;
//
//   return Scaffold(
//     body: Column(
//       children: [
//         Container(
//           constraints: BoxConstraints(
//             minHeight: MediaQuery.of(context).size.width,
//             minWidth: MediaQuery.of(context).size.width,
//           ),
//           child: Center(
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.account_circle,
//                   size: imageSize,
//                 ),
//                 Text('${userName}'),
//                 Text('${userBirth}'),
//                 Text('${userEmail}'),
//                 // Text('${userPassword}'),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
