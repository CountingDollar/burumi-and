import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:team_burumi/modelSign.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Services {
  static const String url = "https://jsonplaceholder.typicode.com/users";

  static Future<List<User>> getInfo() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<User> user = userFromJson(response.body);
        return user;
      } else {
        Fluttertoast.showToast(msg: "Error");
        return <User>[];
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return <User>[];
    }
  }

  Future<void> sendEmailToServer(String email) async {
    // 서버 엔드포인트 URL
    final url = Uri.parse('https://api.example.com/send-email');

    try {
      // POST 요청 보내기
      final response = await http.post(
        url,
        body: {'email': email},
      );

      // 응답 확인
      if (response.statusCode == 200) {
        // 성공적으로 서버에 이메일을 전송한 경우
        print('Email sent successfully');
      } else {
        // 요청이 실패한 경우
        print('Failed to send email');
      }
    } catch (e) {
      // 요청 오류 처리
      print('Error sending email: $e');
    }
  }
}
