  import 'package:dio/dio.dart';
  import 'package:team_burumi/src/models/ErrandGetModel.dart';
  import 'package:flutter/material.dart';
  class errandsApi {
    final Dio _dio = Dio();

    Future<List<Post>> fetchPosts({int page = 1, int size = 20}) async {
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

        if (response.statusCode == 200) {
          // Assuming the API returns a JSON object with a "result" key containing the list of posts
          var result = response.data['result'] as List<dynamic>;
          return result.map((item) => Post.fromJson(item)).toList();
        } else {
          throw Exception(
              'Failed to load posts: ${response.statusCode} ${response
                  .statusMessage}');
        }
      } catch (e) {
        throw Exception('Failed to load posts: $e');
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

      // 요청에 포함할 데이터
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
        final response = await _dio.post(url, data: data);

        if (response.statusCode == 200) {
          print('Errand created successfully');
          print('Response data: ${response.data}');
          Navigator.pop(context);
        } else {
          print('Failed to create errand: ${response.statusCode} ${response.statusMessage}');
        }
      } catch (e) {
        print('Error occurred while creating errand: $e');
      }
    }
  }