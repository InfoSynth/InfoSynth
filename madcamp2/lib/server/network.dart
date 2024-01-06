import 'dart:convert';

import 'package:http/http.dart';

class Network {
  final baseUrl = "http://3.37.132.122:8000";

  // 전체 멤버 탐색
  Future<dynamic> findMembers() async {
    var url = Uri.parse(baseUrl + '/members');
    final response = await get(url);
    var userJson = response.body;
    var parsingData = jsonDecode(userJson);
    return parsingData;
  }

  // 회원가입 또는 멤버 추가
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

  // 로그인 기능
  Future<Map> checkMembers(Map<String, String> checkMember) async {
    try {
      final response = await post(
        Uri.parse(baseUrl + '/login'),
        body: jsonEncode(checkMember),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }
}
