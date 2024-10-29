import 'package:dio/dio.dart';

// Post 모델을 여기서 import하세요
import 'package:team_burumi/src/models/NotificationModel.dart';
import 'package:team_burumi/src/service/JWTapi.dart';
class NoticeApi {
  List<Post> posts = []; // 가져온 게시글을 저장할 리스트

  Future<List<Post>> fetchPosts() async {
    final Dio _dio = Dio();
    String? token = await JwtApi().getToken();
    try {
      final response = await _dio.get(
        'https://api.dev.burumi.kr/v1/posts',
        queryParameters: {
          'type': 'notice', // 쿼리 파라미터로 type을 추가합니다
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('API 응답이 null입니다.');
        }

        ApiResponse apiResponse = ApiResponse.fromJson(response.data);

        if (apiResponse.result == null) {
          throw Exception('result 값이 null입니다.');
        }

        posts = apiResponse.result!.posts; // result가 null이 아님을 확인 후 접근
        return posts;
      } else {
        throw Exception('게시글을 불러오는 데 실패했습니다');
      }
    } catch (e) {
      throw Exception('게시글을 불러오는 데 실패했습니다: $e');
    }
  }
}