import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'LogInApi.dart';

class ApiService {
  final Dio _dio = Dio();
  int _retryCount = 0;  // 로그인 재시도 횟수

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioError error, handler) async {
        if (error.response?.statusCode == 401 && error.response?.data['code'] == 4010) {
          // 토큰 만료 시 자동으로 새 토큰 발급 시도
          final success = await _attemptReLogin();
          if (success) {
            // 새 토큰으로 요청 다시 시도
            return handler.resolve(await _retry(error.requestOptions));
          } else {
            // 재시도 횟수 초과 시 에러 메시지 표시
            print("Login failed after multiple attempts.");
            return handler.next(error);  // 로그인 실패 후, 오류 반환
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<bool> _attemptReLogin() async {
    if (_retryCount >= 3) {
      // 재시도 횟수 제한
      return false;
    }

    _retryCount++;  // 재시도 횟수 증가

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    if (savedEmail != null && savedPassword != null) {
      // 로그인 시도
      final loginSuccess = await ApiLogin().login(savedEmail, savedPassword);
      if (loginSuccess) {
        _retryCount = 0; // 로그인 성공 시 재시도 횟수 초기화
        return true;
      }
    }
    return false;
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(
      requestOptions.path,
      options: options,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }

  Dio get dio => _dio;
}