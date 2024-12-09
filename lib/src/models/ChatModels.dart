class ChatModels {
  final int id;
  final int user1Id;
  final int user2Id;
  final DateTime? deletedAt;
  final DateTime? updatedAt;
  final DateTime createdAt;
  final List<MessageModel>? messages;


  ChatModels({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.deletedAt,
    this.updatedAt,
    required this.createdAt,
    this.messages,

  });

  factory ChatModels.fromJson(Map<String, dynamic> json) {
    return ChatModels(
      id: json['_id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      messages: json['messages'] != null
          ? (json['messages'] as List)
          .map((message) => MessageModel.fromJson(message))
          .toList()
          : null,
    );
  }
}

class MessageModel {
  final int id;
  final int chatId;
  final int senderId;
  final String type;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.type,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      type: json['type'],
      content: json['content'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}


class ErrandsChatModels {
  int? code;
  String? message;
  Result? result;

  ErrandsChatModels({this.code, this.message, this.result});

  ErrandsChatModels.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? iId;
  String? destination;
  String? destinationDetail;
  String? cost;
  String? summary;
  String? details;
  Null? proofImageUrl;
  int? categoryId;
  int? ordererId;
  int? messengerId;
  String? status;
  String? scheduledAt;
  Null? startedAt;
  Null? completedAt;
  Null? closedAt;
  Null? deletedAt;
  Null? updatedAt;
  String? createdAt;
  Orderer? orderer;
  Orderer? messenger;
  Category? category;
  List<Applicants>? applicants;

  Result(
      {this.iId,
        this.destination,
        this.destinationDetail,
        this.cost,
        this.summary,
        this.details,
        this.proofImageUrl,
        this.categoryId,
        this.ordererId,
        this.messengerId,
        this.status,
        this.scheduledAt,
        this.startedAt,
        this.completedAt,
        this.closedAt,
        this.deletedAt,
        this.updatedAt,
        this.createdAt,
        this.orderer,
        this.messenger,
        this.category,
        this.applicants});

  Result.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    destination = json['destination'];
    destinationDetail = json['destination_detail'];
    cost = json['cost'];
    summary = json['summary'];
    details = json['details'];
    proofImageUrl = json['proof_image_url'];
    categoryId = json['category_id'];
    ordererId = json['orderer_id'];
    messengerId = json['messenger_id'];
    status = json['status'];
    scheduledAt = json['scheduled_at'];
    startedAt = json['started_at'];
    completedAt = json['completed_at'];
    closedAt = json['closed_at'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    orderer =
    json['orderer'] != null ? new Orderer.fromJson(json['orderer']) : null;
    messenger = json['messenger'] != null
        ? new Orderer.fromJson(json['messenger'])
        : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['applicants'] != null) {
      applicants = <Applicants>[];
      json['applicants'].forEach((v) {
        applicants!.add(new Applicants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['destination'] = this.destination;
    data['destination_detail'] = this.destinationDetail;
    data['cost'] = this.cost;
    data['summary'] = this.summary;
    data['details'] = this.details;
    data['proof_image_url'] = this.proofImageUrl;
    data['category_id'] = this.categoryId;
    data['orderer_id'] = this.ordererId;
    data['messenger_id'] = this.messengerId;
    data['status'] = this.status;
    data['scheduled_at'] = this.scheduledAt;
    data['started_at'] = this.startedAt;
    data['completed_at'] = this.completedAt;
    data['closed_at'] = this.closedAt;
    data['deleted_at'] = this.deletedAt;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    if (this.orderer != null) {
      data['orderer'] = this.orderer!.toJson();
    }
    if (this.messenger != null) {
      data['messenger'] = this.messenger!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.applicants != null) {
      data['applicants'] = this.applicants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orderer {
  int? iId;
  String? name;
  String? phone;

  Orderer({this.iId, this.name, this.phone});

  Orderer.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}

class Category {
  int? iId;
  String? name;

  Category({this.iId, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['name'] = this.name;
    return data;
  }
}

class Applicants {
  int? iId;
  int? errandId;
  int? userId;
  String? userName;
  String? userPhone;
  Null? deletedAt;
  Null? updatedAt;
  String? createdAt;

  Applicants(
      {this.iId,
        this.errandId,
        this.userId,
        this.userName,
        this.userPhone,
        this.deletedAt,
        this.updatedAt,
        this.createdAt});

  Applicants.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    errandId = json['errand_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['errand_id'] = this.errandId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_phone'] = this.userPhone;
    data['deleted_at'] = this.deletedAt;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
class ErrandDetailModel {
  int? id;
  String? destination;
  String? destinationDetail;
  String? cost;
  String? summary;
  String? details;
  String? proofImageUrl;
  int? categoryId;
  int? ordererId;
  int? messengerId;
  String? status;
  DateTime? scheduledAt;
  DateTime? startedAt;
  DateTime? completedAt;
  DateTime? closedAt;
  DateTime? deletedAt;
  DateTime? updatedAt;
  DateTime? createdAt;
  Orderer? orderer;
  Category? category;
  List<Applicants>? applicants;

  ErrandDetailModel({
    this.id,
    this.destination,
    this.destinationDetail,
    this.cost,
    this.summary,
    this.details,
    this.proofImageUrl,
    this.categoryId,
    this.ordererId,
    this.messengerId,
    this.status,
    this.scheduledAt,
    this.startedAt,
    this.completedAt,
    this.closedAt,
    this.deletedAt,
    this.updatedAt,
    this.createdAt,
    this.orderer,
    this.category,
    this.applicants,
  });

  ErrandDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    destination = json['destination'];
    destinationDetail = json['destination_detail'];
    cost = json['cost'];
    summary = json['summary'];
    details = json['details'];
    proofImageUrl = json['proof_image_url'];
    categoryId = json['category_id'];
    ordererId = json['orderer_id'];
    messengerId = json['messenger_id'];
    status = json['status'];
    scheduledAt = json['scheduled_at'] != null
        ? DateTime.parse(json['scheduled_at'])
        : null;
    startedAt = json['started_at'] != null
        ? DateTime.parse(json['started_at'])
        : null;
    completedAt = json['completed_at'] != null
        ? DateTime.parse(json['completed_at'])
        : null;
    closedAt = json['closed_at'] != null
        ? DateTime.parse(json['closed_at'])
        : null;
    deletedAt = json['deleted_at'] != null
        ? DateTime.parse(json['deleted_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null;
    createdAt = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null;
    orderer = json['orderer'] != null ? Orderer.fromJson(json['orderer']) : null;
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['applicants'] != null) {
      applicants = (json['applicants'] as List)
          .map((applicant) => Applicants.fromJson(applicant))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['destination'] = destination;
    data['destination_detail'] = destinationDetail;
    data['cost'] = cost;
    data['summary'] = summary;
    data['details'] = details;
    data['proof_image_url'] = proofImageUrl;
    data['category_id'] = categoryId;
    data['orderer_id'] = ordererId;
    data['messenger_id'] = messengerId;
    data['status'] = status;
    data['scheduled_at'] = scheduledAt?.toIso8601String();
    data['started_at'] = startedAt?.toIso8601String();
    data['completed_at'] = completedAt?.toIso8601String();
    data['closed_at'] = closedAt?.toIso8601String();
    data['deleted_at'] = deletedAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    data['created_at'] = createdAt?.toIso8601String();
    if (orderer != null) {
      data['orderer'] = orderer!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (applicants != null) {
      data['applicants'] = applicants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
