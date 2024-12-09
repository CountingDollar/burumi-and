
import 'package:json_annotation/json_annotation.dart';
part 'ErrandGetModel.g.dart';



@JsonSerializable()
class ErrandGetModel {
  final int code;
  final String message;
  final List<Delivery> result;

  ErrandGetModel({
    required this.code,
    required this.message,
    required this.result,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory ErrandGetModel.fromJson(Map<String, dynamic> json) => _$ErrandGetModelFromJson(json);

  // Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() => _$ErrandGetModelToJson(this);
}

@JsonSerializable()
class Delivery {
  @JsonKey(name: '_id')
  final int id;
  final String destination;
  final String destinationDetail;
  final String cost;
  final String summary;
  final String details;
  final String? proofImageUrl;
  final int category_id;
  final int? ordererId;
  final int? messengerId;
  final String status;
  final DateTime scheduledAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? closedAt;
  final DateTime? deletedAt;
  final DateTime? updatedAt;
  final DateTime createdAt;

  Delivery({
    this.id = -1,
    this.destination = "Unknown",
    this.destinationDetail = "Unknown",
    this.cost = "0",
    this.summary = "제목 없음",
    this.details = "No details provided",
    this.proofImageUrl,
    this.category_id = 0,
    this.ordererId,
    this.messengerId,
    this.status = "Unknown",
    DateTime? scheduledAt,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
    this.closedAt,
    this.deletedAt,
    this.updatedAt,
  })  : scheduledAt = scheduledAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  // JSON 데이터를 Dart 객체로 변환
  factory Delivery.fromJson(Map<String, dynamic> json) => _$DeliveryFromJson(json);

  // Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}
