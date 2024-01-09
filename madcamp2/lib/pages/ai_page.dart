import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp2/models/response_model.dart';
import 'package:madcamp2/server/network.dart';
const Color primaryColor = Color(0xFF007BFF);
const Color backgroundColor = Colors.white;
const TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 20);

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

  Network network = Network();

  @override
  void initState() {
    // promptController = TextEditingController();
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
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 뉴스 리스트
          Expanded(
            child: ListView.separated(
              // ... 기존의 코드 유지
              itemBuilder: (context, index) => _buildListItem(index),
            ),
          ),
          // 프롬프트 및 텍스트 필드
          Expanded(child: PromptBldr(responseTxt: responseTxt)),
          TextFormFieldBldr(
              promptController: promptController, btnFun: completionFun),
        ],
      ),
    );
  }// 리스트 아이템 빌더
  Widget _buildListItem(int index) {
    return Container(
      height: 50,
      color: backgroundColor,
      child: Center(
        child: Text(
          '${newsList[index]['title']}',
          style: textStyle,
        ),
      ),
    );
  }

  completionFun() async {
    setState(() => responseTxt = 'Loading...');

    final response =
        await http.post(Uri.parse('https://api.openai.com/v1/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${dotenv.env['token']}'
            },
            body: utf8.encode(jsonEncode({
              "model": "gpt-3.5-turbo-instruct",
              "prompt": '"' +
                  promptController.text +
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
}

class TextFormFieldBldr extends StatelessWidget {
  const TextFormFieldBldr(
      {super.key, required this.promptController, required this.btnFun});

  final TextEditingController promptController;
  final Function btnFun;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
        child: Row(children: [
          Flexible(
            child: TextFormField(
              cursorColor: Colors.black,
              controller: promptController,
              autofocus: true,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Ask me anything...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: () {
                  btnFun();
                },
              ),
            ),
          ),
        ]),
      ),
    );
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
