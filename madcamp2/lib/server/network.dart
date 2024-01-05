import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  final String url;

  Network(this.url);

  Future<dynamic> getJsonData() async {
    var url = Uri.parse('http://localhost:8000/get');
    http.Response response = await http.get(Uri.parse(url as String));
    var userJson = response.body;
    var parsingData = jsonDecode(userJson);
    return parsingData;
  }
}
