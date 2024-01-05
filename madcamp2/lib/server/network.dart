import 'dart:convert';
import 'package:http/http.dart';

class Network {
  final baseUrl = "http://localhost:8000";

  Future<dynamic> getJsonData() async {
    var url = Uri.parse(baseUrl +'/members');
    final response = await get(url);
    var userJson = response.body;
    var parsingData = jsonDecode(userJson);
    return parsingData;
  }

  Future<Map> addMembers(Map<String, String> newMember) async {
    try {
      final response = await post(
        Uri.parse(baseUrl + '/members'),
        body: jsonEncode(newMember),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }


}
