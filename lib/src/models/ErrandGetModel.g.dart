// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ErrandGetModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrandGetModel _$ErrandGetModelFromJson(Map<String, dynamic> json) =>
    ErrandGetModel(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      result: (json['result'] as List<dynamic>)
          .map((e) => Delivery.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ErrandGetModelToJson(ErrandGetModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      id: (json['_id'] as num?)?.toInt() ?? -1,
      destination: json['destination'] as String? ?? "Unknown",
      destinationDetail: json['destinationDetail'] as String? ?? "Unknown",
      cost: json['cost'] as String? ?? "0",
      summary: json['summary'] as String? ?? "제목 없음",
      details: json['details'] as String? ?? "No details provided",
      proofImageUrl: json['proofImageUrl'] as String?,
      category_id: (json['category_id'] as num?)?.toInt() ?? 0,
      ordererId: (json['ordererId'] as num?)?.toInt(),
      messengerId: (json['messengerId'] as num?)?.toInt(),
      status: json['status'] as String? ?? "Unknown",
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      '_id': instance.id,
      'destination': instance.destination,
      'destinationDetail': instance.destinationDetail,
      'cost': instance.cost,
      'summary': instance.summary,
      'details': instance.details,
      'proofImageUrl': instance.proofImageUrl,
      'category_id': instance.category_id,
      'ordererId': instance.ordererId,
      'messengerId': instance.messengerId,
      'status': instance.status,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
