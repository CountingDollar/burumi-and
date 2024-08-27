import 'package:dio/dio.dart';

class PostResponse {
  final int code;
  final String message;
  final Post result;

  PostResponse({
    required this.code,
    required this.message,
    required this.result,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      code: json['code'],
      message: json['message'],
      result: Post.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'result': result,
    };
  }
}
class Post {
  final int id;
  final String destination;
  final String destinationDetail;
  final String cost;
  final String summary;
  final String details;
  final int? categoryId;
  final String? scheduledAt;
  final String status;
  final String createdAt;

  Post({
    required this.id,
    required this.destination,
    required this.destinationDetail,
    required this.cost,
    required this.summary,
    required this.details,
    required this.categoryId,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      destination: json['destination'],
      destinationDetail: json['destination_detail'],
      cost: json['cost'],
      summary: json['summary'],
      details: json['details'],
      categoryId: json['category_id'],
      scheduledAt: json['scheduled_at'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'destination': destination,
      'destination_detail': destinationDetail,
      'cost': cost,
      'summary': summary,
      'details': details,
      'category_id': categoryId,
      'scheduled_at': scheduledAt,
      'status': status,
      'created_at': createdAt,
    };
  }
}