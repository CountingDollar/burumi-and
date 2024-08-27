  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:dio/dio.dart';
  class JwtApi {
    final Dio _dio = Dio();
    Future<void> saveToken(String token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      print('토큰저장 완료:${getToken()}');
  }

    Future<String?> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwt_token');
    }

    Future<void> removeToken() async {
      final prefs = await SharedPreferences.getInstance();
      bool result = await prefs.remove('jwt_token');
      print(result ? '토큰 삭제 성공' : '토큰 삭제 실패');
    }

    Future<bool> fetchUserProfile() async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token'); // 저장된 토큰 가져오기

      if (token == null) {
        print('토큰이 없습니다. 로그인이 필요합니다.');
        return false;
      }

      try {
        final response = await _dio.get(
          'https://api.dev.burumi.kr/v1/auth/verify',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // Bearer 토큰 설정
            },
          ),
        );

        if (response.statusCode == 200) {
          // 서버로부터 프로필 정보 가져오기 성공
          print('프로필 정보: ${response.data}');
          return true;
        } else {
          print('프로필 정보 가져오기 실패: 서버 응답 오류 ${response.statusCode}');
        return false;
        }
      } catch (e) {
        print('프로필 정보 가져오기 실패: $e');
        return false;
      }
    }
  }