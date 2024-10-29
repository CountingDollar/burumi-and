import 'package:dio/dio.dart';

class CategoryApi {
  final Dio _dio = Dio();

  Future<List<dynamic>> getCategory() async {
    try {
      final response = await _dio.get('https://api.dev.burumi.kr/v1/errands/categories');
      if (response.statusCode == 200) {
        print("카테고리 생성 완료");
        return response.data['result']; // 데이터를 반환
      } else {
        print("카테고리 생성 실패");
        return []; // 실패 시 빈 리스트 반환
      }
    } catch (e) {
      print("카테고리 생성 오류 발생: $e");
      return []; // 예외 발생 시 빈 리스트 반환
    }
  }
}