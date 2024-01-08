import 'dart:convert';
import 'package:http/http.dart';

class Network {
  // final baseUrl = "http://3.37.132.122:8000";
  final baseUrl = "http://localhost:8000/api/users";
  String yourToken = "";

  // 전체 멤버 탐색
  Future<dynamic> allMember() async {
    var url = Uri.parse(baseUrl + '/');
    final response = await get(
      url,
      headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $yourToken"
      },
    );
    var userJson = response.body;
    var parsingData = jsonDecode(userJson);
    return parsingData;
  }

  // 회원가입 또는 멤버 추가
  Future<Map> addMember(Map<String, String> newMember) async {
    var url = Uri.parse(baseUrl + '/');

    try {
      final response = await post(
        url,
        body: jsonEncode(newMember),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $yourToken"
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map> getMember(String id) async {
    var url = Uri.parse(baseUrl + '/'+ id);
    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $yourToken"
        },
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData;
    } catch (e) {
      print(e);
      return {};
    }
  }
  Future<Map> checkMemberByEmail(Map<String, String> checkMember) async {
    var url = Uri.parse(baseUrl + '/'+ checkMember['email'].toString());
    try {
      final response = await get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $yourToken"
        },
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      return parsingData;
    } catch (e) {
      print(e);
      return {};
    }
  }
  Future<Map> updateMember(Map<String, String> updateMember) async {
    var url = Uri.parse(baseUrl + '/');
    try {
      final response = await  put(
        url,
        body: jsonEncode(updateMember),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $yourToken"
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<dynamic> login(Map<String, String> checkMember) async {
    var url = Uri.parse(baseUrl + '/login');
    try {
      final response = await post(
        url,
        body: jsonEncode(checkMember),
        headers: {"Content-Type": "application/json"},
      );
      var userJson = response.body;
      var parsingData = jsonDecode(userJson);
      yourToken = parsingData['token'];
      return parsingData;
    } catch (e) {
      print(["error",e]);
      return {};
    }
  }



}
