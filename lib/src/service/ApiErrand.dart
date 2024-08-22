import 'package:dio/dio.dart';
import 'package:team_burumi/src/models/ErrandGetModel.dart';
class errandslist {
  final Dio _dio = Dio();

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _dio.get('https://api.dev.burumi.kr/mocks/errands');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.statusCode == 200) {

        List<dynamic> data = response.data;
        print('Response data: ${response.data}');
        print('Result data: $data');
        return data.map((item) => Post.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load posts${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load posts $e');
    }
  }
}