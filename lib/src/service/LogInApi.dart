import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiLogin {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // API 요청
      final response = await _dio.post(
        'https://api.dev.burumi.kr/v1/auth/login',
        data: {'email': email, 'password': password},
      );

      // 응답 성공
      if (response.statusCode == 200 && response.data['code'] == 2000) {
        final result = response.data['result'];

        // access_token 유효성 확인
        if (result == null || result['access_token'] == null) {
          throw Exception('로그인 응답에 access_token이 없습니다.');
        }

        // access_token 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', result['access_token']);

        return {
          'code': 2000,
          'message': 'login.success',
          'token': result['access_token'],
        };
      }

      // 실패 응답 처리
      final detailMessage = response.data['detail']?['message'] ?? '로그인 실패';
      return {
        'code': response.data['code'],
        'message': response.data['message'],
        'detail': {'message': detailMessage},
      };
    } on DioError catch (dioError) {
      // Dio 오류 처리
      print('로그인 API Dio 오류: ${dioError.response?.data ?? dioError.message}');
      return {
        'code': 5000,
        'message': 'network.error',
        'detail': {'message': '네트워크 오류가 발생했습니다. 다시 시도해주세요.'},
      };
    } catch (e) {
      // 일반 오류 처리
      print('로그인 API 일반 오류: $e');
      return {
        'code': 5000,
        'message': 'server.error',
        'detail': {'message': '서버와의 연결에 문제가 발생했습니다.'},
      };
    }
  }
}
