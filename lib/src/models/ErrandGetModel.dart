import 'package:dio/dio.dart';

class Post {
  final int id;
  final String destination;
  final String destinationDetail;
  final int cost;
  final int categoryId;
  final String summary;
  final String details;
  final String status;
  final String? closedAt;
  final String? proofImageUrl;
  final int ordererId;
  final int messengerId;

  Post({
    required this.id,
    required this.destination,
    required this.destinationDetail,
    required this.cost,
    required this.categoryId,
    required this.summary,
    required this.details,
    required this.status,
    this.closedAt,
    this.proofImageUrl,
    required this.ordererId,
    required this.messengerId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      destination: json['destination'],
      destinationDetail: json['destination_detail'],
      cost: int.parse(json['cost']),
      categoryId: json['category_id'],
      summary: json['summary'],
      details: json['details'],
      status: json['status'],
      closedAt: json['closed_at'], // 처리 방식 수정
      proofImageUrl: json['proof_image_url'],
      ordererId: json['orderer_id'],
      messengerId: json['messenger_id'],
    );
  }
}
