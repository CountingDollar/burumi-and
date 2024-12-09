import 'package:dio/dio.dart';
import '../models/ChatModels.dart';
import '../service/ApiService.dart';



class ChatApi {

  final Dio _dio = ApiService().dio;
  final String baseUrl = "https://api.dev.burumi.kr/v1/chats";

  Future<ErrandDetailModel> fetchErrandDetail(int errandId) async {
    try {
      final response = await ApiService().dio.get('https://api.dev.burumi.kr/v1/errands/$errandId');

      if (response.data['code'] == 2000) {
        return ErrandDetailModel.fromJson(response.data['result']);
      } else {
        throw Exception("API Error: ${response.data['message']}");
      }
    } catch (e) {
      print("fetchErrandDetail 오류: $e");
      throw Exception("게시글 상세 조회 실패.");
    }
  }
  Future<MessageModel?> fetchLastMessage(int chatId) async {
    try {
      final response = await ApiService().dio.get('https://api.dev.burumi.kr/v1/chats/$chatId');

      if (response.data['code'] == 2000) {
        final messages = response.data['result']['messages'] as List<dynamic>;

        if (messages.isEmpty) return null;

        final lastMessage = messages.first;
        return MessageModel(
          id: lastMessage['_id'],
          chatId: lastMessage['chat_id'],
          senderId: lastMessage['sender_id'],
          type: lastMessage['type'],
          content: lastMessage['content'],
          createdAt: DateTime.parse(lastMessage['created_at']),
          imageUrl: lastMessage['image_url'],
        );
      } else {
        throw Exception("API 오류: ${response.data['message']}");
      }
    } catch (e) {
      print('fetchLastMessage 오류: $e');
      return null;
    }
  }



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

    if (response.data['code'] == 2000) {
      return ChatModels.fromJson(response.data['result']);
    } else {
      throw Exception('Failed to load chat details');
    }
  }

  // 채팅방 생성
  Future<ChatModels> createChat({required int user1Id, required int user2Id, required int errandId}) async {
    final response = await _dio.post(baseUrl, data: {
      'user1_id': user1Id,
      'user2_id': user2Id,
    });

    if (response.data['code'] == 2000) {
      final chatId = response.data['result']['_id'];
      await sendMessage(chatId: chatId, type: 'text', content: 'POST_ID:$errandId');
      print('채팅방생성 성공');
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
    if ((content == null || content.trim().isEmpty) && imageUrl == null) {
      throw Exception('메시지 또는 이미지를 입력해주세요.');
    }

    final response = await _dio.post('$baseUrl/$chatId/messages', data: {
      'type': type,
      'content': content.trim(),
      if (imageUrl != null) 'image_url': imageUrl,
    });

    if (response.data['code'] == 2000) {
      print('메세지전송 성공');
      return MessageModel.fromJson(response.data['result']);
    } else {
      throw Exception('Failed to send message');
    }
  }
}