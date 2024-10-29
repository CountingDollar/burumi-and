  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:dio/dio.dart';
  class JwtApi {
    final Dio _dio = Dio();
    final String _url = 'https://api.dev.burumi.kr/v1/auth/verify';


    Future<void> saveToken(String token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      print('토큰저장 완료:$token');
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

    // Future<bool> fetchUserProfile() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   String? token = prefs.getString('jwt_token'); // 저장된 토큰 가져오기
    //
    //   if (token == null) {
    //     print('토큰이 없습니다. 로그인이 필요합니다.');
    //     return false;
    //   }
    //
    //   try {
    //     final response = await _dio.get(
    //       _url,
    //       options: Options(
    //         headers: {
    //           'Authorization': 'Bearer $token', // Bearer 토큰 설정
    //         },
    //       ),
    //     );
    //
    //     if (response.statusCode == 200) {
    //       print('프로필 정보: ${response.data}');
    //       return true;
    //     } else {
    //       print('프로필 정보 가져오기 실패: 서버 응답 오류 ${response.statusCode}');
    //     return false;
    //     }
    //   } catch (e) {
    //     print('프로필 정보 가져오기 실패: $e');
    //     return false;
    //   }
    // }

    Future<String?> getUserName(String token) async {
      try {
        final response = await _dio.get(
          _url,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          final data = response.data;
          print(data['message']);
          // 응답에서 이름을 추출하여 반환합니다.
          if (data['code'] == 2000) {
            print(data['message']);
            print(data['result']['name']);
            return data['result']['name'];
          } else {
            print('API Error: ${data['message']}');
            return null;
          }
        } else {
          print('dio Error: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        print('Error: $e');
        return null;
      }
    }
  }
