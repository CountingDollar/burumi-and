import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'LogInApi.dart';
import '../../Main.dart';
import 'package:flutter/widgets.dart';


class ApiService {
  final Dio _dio = Dio();
  int _retryCount = 0;

  ApiService() {
    print('ApiService 생성자 호출됨');
    print('Dio 인스턴스 생성 중....');
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('API 요청 시작: ${options.uri}');
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('API 응답 수신: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioError error, handler) async {
        print('onError 인터셉터 실행: ${error.response?.statusCode}');
        if (error.response?.statusCode == 401 && error.response?.data['code'] == 4010) {
          print('4010 Unauthorized 발생: 토큰 갱신 시도 중...');
          final success = await _attemptReLogin();
          if (success) {
            return handler.resolve(await _retry(error.requestOptions));
          } else {
            print('재로그인 실패로 로그인 페이지로 이동');
            _redirectToLogin();
          }
        } else {
          print('API 요청 실패: ${error.response?.data}');
        }
        return handler.next(error);
      },
    ));
    print('Dio 인스턴스 및 인터셉터 설정 완료');
  }

  Future<bool> _attemptReLogin() async {
    print('_attemptReLogin 호출');
    if (_retryCount >= 3) {
      print('재시도 횟수 초과로 로그인 페이지로 이동');
      _redirectToLogin();
      return false;
    }

    _retryCount++;
    print('현재 재시도 횟수: $_retryCount');

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    if (savedEmail == null || savedPassword == null) {
      print('저장된 자격 증명이 없습니다. 로그인 페이지로 이동');
      _redirectToLogin();
      return false;
    }

    try {
      final loginResponse = await ApiLogin().login(savedEmail, savedPassword);
      print('재로그인 응답: ${loginResponse.toString()}');
      if (loginResponse['code'] == 2000) {
        _retryCount = 0; // 성공 시 초기화
        print('재로그인 성공');
        return true;
      } else {
        final detailMessage = loginResponse['detail']?['message'] ?? '알 수 없는 오류';
        print('재로그인 실패: $detailMessage');
        _redirectToLogin();
        return false;
      }
    } catch (e) {
      print('재로그인 중 예외 발생: $e');
      _redirectToLogin();
      return false;
    }
  }

  void _redirectToLogin() {
    print('Navigator 상태: ${MyApp.navigatorKey.currentState}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MyApp.navigatorKey.currentState != null) {
        print('로그인 화면으로 이동 중...');
        MyApp.navigatorKey.currentState!.pushReplacementNamed('/login');
      } else {
        print('Navigator 상태가 null입니다. 로그인 화면으로 이동 실패');
      }
    });
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
