class ChatOverview {
  final int id;
  final int user1Id;
  final int user2Id;
  final DateTime? deletedAt;
  final DateTime? updatedAt;
  final DateTime createdAt;

  ChatOverview({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.deletedAt,
    this.updatedAt,
    required this.createdAt,
  });

  factory ChatOverview.fromJson(Map<String, dynamic> json) {
    return ChatOverview(
      id: json['_id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Message {
  final int id;
  final int chatId;
  final int senderId;
  final String type;
  final String content;
  final DateTime createdAt;
  final String? imageUrl;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.type,
    required this.content,
    required this.createdAt,
    this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      type: json['type'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      imageUrl: json['image_url'],
    );
  }
}
