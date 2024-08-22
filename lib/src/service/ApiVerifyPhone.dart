import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();


  Future<bool> createUser({
    required String name,
    required String phone,
    required String email,
    required String password,
    // required String verifyCode,
  }) async {
    final url = 'https://api.dev.burumi.kr/v1/users';
    try {
      final response = await _dio.post(
        url,
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
          // 'verify_code': verifyCode,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('유저 생성 성공: ${response.data}');
        return true; // 성공 시 true 반환
      } else {
        print('서버 응답 오류: ${response.statusCode}');
        return false; // 실패 시 false 반환
      }
    } catch (e) {
      print('에러 발생: $e');
      return false; // 예외 발생 시 false 반환
    }
  }


  // 전화번호 인증번호 전송
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


  // 인증번호 유효성 확인
  Future<bool> verifyCode(String phoneNumber, String code) async {
    final url = 'https://api.dev.burumi.kr/v1/auth/verify/phone';
    try {
      final response = await _dio.get(url, queryParameters: {
        'phone': phoneNumber,
        'code': code,
      });

      if (response.statusCode == 200) {
        final isValid = response.data['result'];

        if (isValid) {
          print('인증번호가 유효합니다.');
          return true;
        } else {
          print('인증번호가 유효하지 않습니다.');
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
