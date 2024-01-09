import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp2/models/response_model.dart';
import 'package:madcamp2/server/network.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

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
      backgroundColor: const Color(0xff343541),
      appBar: AppBar(
        title: const Text('Flutter and ChatGPT',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff343541),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: PromptBldr(responseTxt: responseTxt)),
          TextFormFieldBldr(
              promptController: promptController, btnFun: completionFun),
        ],
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
              "prompt":
                  'read the following script and give only 3 important proper nouns in Korean. Just give me 3 words separated by commas.  ' +
                      promptController.text,
              "max_tokens": 250,
              "temperature": 0,
              "top_p": 1,
            })));

    // print('Raw Response: ${response.body}');

    // if (response.statusCode == 200) {
    //   try {
    //     final Map<String, dynamic> responseBody = jsonDecode(response.body);
    //     _responseModel = ResponseModel.fromMap(responseBody);
    //     setState(() {
    //       responseTxt = _responseModel.choices[0].text;
    //     });
    //   } catch (e) {
    //     // Handle JSON decoding error
    //     setState(() {
    //       responseTxt = 'Error decoding response';
    //       print('Raw Response: ${response.body}');
    //     });
    //   }
    // } else {
    //   // Handle HTTP request error
    //   setState(() {
    //     responseTxt = 'Error: ${response.statusCode}';
    //   });
    // }

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
    network.sendKeyword(words);
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
              cursorColor: Colors.white,
              controller: promptController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xff444653),
                  ),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff444653),
                  ),
                ),
                filled: true,
                fillColor: const Color(0xff444653),
                hintText: 'Ask me anything...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Container(
            color: const Color(0xff19bc99),
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
          )
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
      color: const Color(0xff434654),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Text(
              responseTxt,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
