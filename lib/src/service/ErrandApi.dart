import 'package:dio/dio.dart';
import 'package:team_burumi/src/models/ErrandGetModel.dart';
import 'package:flutter/material.dart';
import 'package:team_burumi/src/service/JWTapi.dart';
import '../service/ApiService.dart';


class errandsApi {
  final Dio _dio = ApiService().dio;

  Future<Map<String, dynamic>> fetchPosts({int page = 1, int size = 20}) async {
    try {
      final response = await _dio.get(
        'https://api.dev.burumi.kr/v1/errands',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.data['code'] == 2000) {
        var result = response.data['result']['errands'] as List<dynamic>;
        var count = response.data['result']['count'];
        return {
        'errands':result.map((item) => Delivery.fromJson(item)).toList(),
        'count':count
        };
        } else {
        throw Exception(
            'Failed to load posts: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  /*
  Future<Map<String, dynamic>> fetchPosts({int page = 1, int size = 20}) async {
    try {
      final response = await _dio.get(
        'https://api.dev.burumi.kr/v1/errands',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data['code'] == 2000) {
        final result = response.data['result']['errands'] as List<dynamic>;
        final errands = result.map((item) => Delivery.fromJson(item)).toList();
        final count = response.data['result']['count'];
        return {'errands': errands, 'count': count};
      } else {
        throw Exception(
            'Failed to load posts: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }
*/




  Future<void> applyForErrand(int errandId) async {
    try {
      final response = await _dio.post(
        'https://api.dev.burumi.kr/v1/errands/$errandId/applicants',
      );

      if (response.data['code'] != 2000) {
        throw Exception('심부름 지원 실패.: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Error applying for errand: $e');
    }
  }

  Future<void> createErrand({
    required BuildContext context,
    required String destination,
    required String destinationDetail,
    required String cost,
    required String summary,
    required String details,
    required String categoryId,
    required String scheduledAt,
  }) async {
    final String url = 'https://api.dev.burumi.kr/v1/errands';
    String? token = await JwtApi().getToken();

    final Map<String, dynamic> data = {
      "destination": destination,
      "destination_detail": destinationDetail,
      "cost": cost,
      "summary": summary,
      "details": details,
      "category_id": categoryId,
      "scheduled_at": scheduledAt,
    };

    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['code'] == 2000) {
        print('심부름 생성 성공');
        print('생성한 심부름 : ${response.data}');
        Navigator.pop(context);
      } else {
        print(
            '심부름을 생성하지 못했습니다: ${response.statusMessage}');

      }
    } catch (e) {
      print('심부름 생성 오류: $e');
    }
  }
}
