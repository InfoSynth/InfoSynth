import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

enum genderType { male, female }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;

  String? birth = "0000-00-00";
  genderType? gender;
  String? email;
  String? password;

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
              child: Icon(
                Icons.account_circle,
                size: imageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/AppLogo.png",
                      width: 180,
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 30,
                top: 50,
              ),
              child: Text(
                "프로필",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            FormHelper.inputFieldWidget(
              context,
              "username",
              "이름(닉네임)",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Username can\'t be empty.';
                }

                return null;
              },
                  (onSavedVal) {
                username = onSavedVal;
              },
              borderFocusColor: Colors.white,
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: true,
              prefixIcon: Icon(Icons.person),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "email",
                "이메일",
                    (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return 'Email can\'t be empty.';
                  }

                  return null;
                },
                    (onSavedVal) {
                  email = onSavedVal;
                },
                borderFocusColor: Colors.white,
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: true,
                prefixIcon: Icon(Icons.account_box),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "password",
                "비밀번호",
                    (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }

                  return null;
                },
                    (onSavedVal) {
                  password = onSavedVal;
                },
                borderFocusColor: Colors.white,
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                borderRadius: 10,
                showPrefixIcon: true,
                prefixIcon: Icon(Icons.password),
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: Colors.white.withOpacity(0.7),
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Row의 크기를 최소화
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (birth != null)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "생년월일: $birth",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Row의 크기를 최소화
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "성별: $gender",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: DropdownButton(
                        value: gender,
                        items: genderType.values.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value == genderType.male ? 'Male' : 'Female',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedGender) {
                          // Handle value change
                          setState(() {
                            gender = selectedGender as genderType?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton(
                "회원가입",
                    () {},
                btnColor: HexColor("#283B71"),
                borderColor: Colors.white,
                txtColor: Colors.white,
                borderRadius: 10,
              ),
            ),
          ]),
    );
  }

}
