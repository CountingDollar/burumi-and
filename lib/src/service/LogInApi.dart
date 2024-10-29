import 'package:dio/dio.dart';

import '../models/LoginModel.dart';
import '../service/JWTapi.dart';

class ApiLogin {

  final Dio _dio = Dio();
  final JwtApi _jwtApi = JwtApi();

  Future<bool> login(String email, String password) async {
    final url = "https://api.dev.burumi.kr/v1/auth/login";

    try {

      final response = await _dio.post(
        url,
        data: {'email': email, 'password': password},
      );


      if (response.statusCode == 200) {

        final loginResponse = LoginResponse.fromJson(response.data);

        if (loginResponse.code == 2000) {
          print('로그인 성공: ${loginResponse.message}${loginResponse.code}');
          if (loginResponse.code == 2000) {
            final String accessToken = loginResponse.result.accessToken;
            _jwtApi.saveToken(accessToken);
            print('토큰 저장${_jwtApi.getToken()}');
          } else {
            print('Access token is null');
            return false;
          }
          return true;
        } else {
          print('로그인 실패: ${loginResponse.message}');
          return false;
        }
      } else {
        print('서버 응답 오류: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('에러 발생: $e');
      return false;
    }
  }
  }

