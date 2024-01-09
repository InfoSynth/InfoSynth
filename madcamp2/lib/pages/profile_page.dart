import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:madcamp2/server/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/user.dart';

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

  Network network = Network();

  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;

  final double coverHeight = 280;
  final double profileHeight = 144;

  XFile? background_image; //이미지를 담을 변수 선언
  XFile? profile_image; //이미지를 담을 변수 선언

  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  Future getImageBackground(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(
        source: imageSource,
        imageQuality: 30,
    );
    if (pickedFile != null) {
      setState(() {
        background_image = pickedFile!; //가져온 이미지를 _image에 저장
      });
      var formData = await FormData.fromMap({'background_image': await MultipartFile.fromFile(pickedFile.path)});
      await network.patchUserBackGroundImage(formData);
    }
  }
  Future getImageProfile(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(
      source: imageSource,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      setState(() {
        profile_image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  XFile? _imageBack; //이미지를 담을 변수 선언
  XFile? _imageProfile; //이미지를 담을 변수 선언
  final ImagePicker picker1 = ImagePicker(); //ImagePicker 초기화
  final ImagePicker picker2 = ImagePicker(); //ImagePicker 초기화

  Future getImageBack(ImageSource imageSource) async {
    final XFile? pickedFile = await picker1.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _imageBack = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  // Future getImageProfile(ImageSource imageSource) async {
  //   final XFile? pickedFile = await picker2.pickImage(source: imageSource);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageProfile = XFile(pickedFile.path); //가져온 이미지를 _imageProfile에 저장
  //     });
  //   }
  // }

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

    DateTime date = DateTime.parse(checked_data['birth']);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    setState(() {
      userName = checked_data['name'];
      userBirth = formattedDate;
      // userGender = checked_data['gender'];
      userEmail = checked_data['email'];
      userPassword = checked_data['password'];
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
          SizedBox(height: 20),
          buildCenter(),
          buildBottom(),
          SizedBox(height: 30),
          buildEditButton(),
          _buildButtonBackground(),
          _buildButtonProfile(),
          _buildPhotoArea(),

        ],
      ),
    );
  }


  Widget _buildPhotoArea() {
    return background_image != null
        ? Container(
      width: 30,
      height: 30,
      child: Image.file(File(background_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    );
  }

  Widget buildImageButtonBack() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey,
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  getImageBack(
                      ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
                },
                child: Center(
                  child: Icon(Icons.camera_alt, size: 22, color: Colors.white),
                ),
              ),
            )),
        SizedBox(width: 6),
        CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey,
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  getImageBack(
                      ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
                },
                child: Center(
                  child: Icon(Icons.photo, size: 22, color: Colors.white),
                ),
              ),
            )),
      ],
    );
  }

  Widget buildImageButtonProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  getImageProfile(
                      ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
                },
                child: Center(
                  child: Icon(Icons.camera_alt, size: 22, color: Colors.black),
                ),
              ),
            )),
        SizedBox(width: 6),
        CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  getImageProfile(
                      ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
                },
                child: Center(
                  child: Icon(Icons.photo, size: 22, color: Colors.black),
                ),
              ),
            )),
      ],
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
        Positioned(bottom: bottom + 5, right: 5, child: buildImageButtonBack()),
        Positioned(top: top, child: buildProfileImage()),
        Positioned(top: top + profileHeight, child: buildImageButtonProfile()),
      ],
    );
  }

  Widget _buildButtonBackground() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(

          onPressed: () {
            getImageBackground(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text("카메라"),
        ),
        SizedBox( width: 30 ),
        ElevatedButton(
          onPressed: () {
            getImageBackground(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
        ),
      ],
    );
  }
  Widget _buildButtonProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImageProfile(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text("카메라"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImageProfile(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
        ),
      ],
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: _imageBack != null
          ? Image.file(File(_imageBack!.path),
              width: double.infinity, height: coverHeight, fit: BoxFit.cover)
          : Image.network(
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
        backgroundImage: _imageProfile != null
            ? FileImage(File(_imageProfile!.path)) as ImageProvider<Object>?
            : NetworkImage("https://source.unsplash.com/random"),
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
}
