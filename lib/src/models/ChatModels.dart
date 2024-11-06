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
