import 'package:dio/dio.dart';
import '../models/ChatModels.dart';
import '../service/ApiService.dart';

class ChatApi {

  final Dio _dio = ApiService().dio;
  final String baseUrl = "https://api.dev.burumi.kr/v1/chats";

  // 채팅방 조회
  Future<List<ChatModels>> fetchAllChats({
    required int user1Id,
    int? user2Id,
    int page = 1,
    int size = 20,
  }) async {
    final response = await _dio.get(baseUrl, queryParameters: {
      'user1_id': user1Id,
      if (user2Id != null) 'user2_id': user2Id,
      'page': page,
      'size': size,
    });

    if (response.data['code'] == 2000) {
      final data = response.data['result']['chats'] as List;
      return data.map((chat) => ChatModels.fromJson(chat)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  // 채팅방 상세 조회
  Future<ChatModels> fetchChatDetails(int chatId, {int page = 1, int size = 20}) async {
    final response = await _dio.get('$baseUrl/$chatId', queryParameters: {
      'page': page,
      'size': size,
    });

    if (response.statusCode == 200) {
      return ChatModels.fromJson(response.data['result']);
    } else {
      throw Exception('Failed to load chat details');
    }
  }

  // 채팅방 생성
  Future<ChatModels> createChat({required int user1Id, required int user2Id}) async {
    final response = await _dio.post(baseUrl, data: {
      'user1_id': user1Id,
      'user2_id': user2Id,
    });

    if (response.data['code'] == 2000) {
      return ChatModels.fromJson(response.data['result']);
    } else {
      throw Exception('Failed to create chat');
    }
  }

  // 메시지 전송
  Future<MessageModel> sendMessage({
    required int chatId,
    required String type,
    required String content,
    String? imageUrl,
  }) async {
    final response = await _dio.post('$baseUrl/$chatId/messages', data: {
      'type': type,
      'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
    });

    if (response.data['code'] == 2000) {
      return MessageModel.fromJson(response.data['result']);
    } else {
      throw Exception('Failed to send message');
    }
  }
}
