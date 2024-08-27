import 'package:dio/dio.dart';


import '../models/SignUpModel.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<bool> createUser(User user) async {
    final url = 'https://api.dev.burumi.kr/v1/users';

    try {
      final response = await _dio.post(
        url,
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        // 응답 데이터 파싱
        final apiResponse = ApiResponse.fromJson(response.data);

        if (apiResponse.code == 2000) {
          // 유저 생성 성공
          print('유저 생성 성공: ${apiResponse.result}');
          return true;
        } else {
          // 서버 응답 코드가 2000이 아닌 경우
          print('서버 응답 오류: ${apiResponse.message}');
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

  Future<void> sendVerificationCode(String phoneNumber) async {
    final url = 'https://api.dev.burumi.kr/v1/auth/verify/phone';
    try {
      final response = await _dio.post(
        url,
        data: {
          'phone': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        final resultCode = response.data['result_code'];
        final message = response.data['message'];

        if (message == 'api.ok') {
          print('인증번호 전송 성공: $message');
        } else {
          print('인증번호 전송 실패: $message');
        }
      } else {
        print('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  Future<bool> verifyCode(String phoneNumber, String code) async {
    final url = 'https://api.dev.burumi.kr/v1/auth/verify/phone';

    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'phone': phoneNumber,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        print('서버 응답 데이터: ${response.data}');
        final verifyCodeResponse = VerifyCodeResponse.fromJson(response.data);

        if (verifyCodeResponse.result) {
          print('인증번호가 유효합니다.');
          return true;
        } else {
          print('인증번호가 유효하지 않습니다: ${verifyCodeResponse.message}');
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
