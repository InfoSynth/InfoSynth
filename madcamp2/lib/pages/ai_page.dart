import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp2/models/response_model.dart';
import 'package:madcamp2/server/network.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:url_launcher/url_launcher.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

List<dynamic> newsList = [];

class _AIPageState extends State<AIPage> {
  late final TextEditingController promptController = TextEditingController();
  String responseTxt =
      ''; // updated with the data which we get from the ai model
  late ResponseModel _responseModel;
  String url = '';
  String script = '';
  bool isAPIcallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  Network network = Network();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Form(
          key: globalFormKey,
          child: _aiUI(context),
        ),
        inAsyncCall: isAPIcallProcess,
        opacity: 0.3,
        key: UniqueKey(),
      ),
    );
  }

  Widget _aiUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: FormHelper.inputFieldWidget(
                    context,
                    "url",
                    "url을 입력해주세요.",
                    (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return 'url을 입력해주세요.';
                      }

                      if (validateYouTubeUrl(onValidateVal) != null) {
                        return validateYouTubeUrl(onValidateVal);
                      }

                      return null;
                    },
                    (onSavedVal) {
                      url = onSavedVal;
                    },
                    borderFocusColor: Colors.black,
                    prefixIconColor: Colors.black,
                    borderColor: Colors.black,
                    textColor: Colors.black,
                    hintColor: Colors.black.withOpacity(0.7),
                    borderRadius: 10,
                    showPrefixIcon: true,
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 75,
                  height: 45,
                  child: FormHelper.submitButton(
                    "검색",
                    () async {
                      if (validateAndSave()) {
                        var scriptMap = await network.sendUrl(url);
                        setState(() {
                          script = scriptMap['data'];
                        });
                      }
                    },
                    btnColor: Colors.white,
                    borderColor: Colors.black,
                    txtColor: Colors.black,
                    borderRadius: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: newsList.length,
            itemBuilder: (BuildContext context, int index) {
              // Use GestureDetector or InkWell for tap functionality
              return GestureDetector(
                onTap: () {
                  // Handle tap action here, for example, open a link
                  String link = newsList[index]['link'];
                  // Navigate to the link or perform other actions
                  launch('$link', forceSafariVC: true);
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
                    child: Center(child: Text('${newsList[index]['title']}')),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
        Expanded(child: PromptBldr(responseTxt: responseTxt)),
      ],
    );
  }

  completionFun() async {
    final response =
        await http.post(Uri.parse('https://api.openai.com/v1/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${dotenv.env['token']}'
            },
            body: utf8.encode(jsonEncode({
              "model": "gpt-3.5-turbo-instruct",
              "prompt": '"' +
                  script +
                  '" read the given script and give only 3 important proper nouns in Korean. Just give me 3 words separated by commas.  ',
              "max_tokens": 50,
              "temperature": 0,
              "top_p": 1,
            })));

    try {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _responseModel = ResponseModel.fromMap(responseBody);
      setState(() {
        responseTxt = utf8.decode(responseBody['choices'][0]['text'].codeUnits);
      });
    } catch (e) {
      print('Error decoding JSON: $e');
      setState(() {
        responseTxt = 'Error decoding response';
      });
    }

    List<String> words = responseTxt.split(',');
    var news = await network.sendKeyword(words);
    setState(() {
      newsList = news['data'];
    });
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String? validateYouTubeUrl(String value) {
    String pattern =
        r'^https:\/\/www\.youtube\.com\/watch\?v=[\w-]+$'; // YouTube video URL format
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'The URL is not a valid YouTube video URL.';
    }
    return null;
  }
}

class PromptBldr extends StatelessWidget {
  const PromptBldr({super.key, required this.responseTxt});

  final String responseTxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.35,
      color: Colors.white,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Text(
              responseTxt,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
