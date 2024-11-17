import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ChatModels.dart';
import '../service/ChatApi.dart';
import '../service/ImageApi.dart';
import '../service/JWTapi.dart';


class ChatScreen extends StatefulWidget {
  final int chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatApi _chatApi = ChatApi();
  final ImageApi _imageApi = ImageApi();
  List<MessageModel> messages = [];
  final TextEditingController _messageController = TextEditingController();
  Timer? _timer;
  final ImagePicker _picker = ImagePicker();

  late int currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
    _fetchMessages();
    _startPolling();
  }

  Future<void> _initializeCurrentUser() async {

    if (JwtApi.user1Id == null) {
      await JwtApi().verifyTokenAndSaveUserId();
    }
    setState(() {
      currentUserId = JwtApi.user1Id ?? -1;
    });

    if (currentUserId == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 ID를 불러오는 데 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      final chatDetails = await _chatApi.fetchChatDetails(widget.chatId);
      setState(() {
        messages = (chatDetails.messages ?? [])
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메시지를 불러오는 데 실패했습니다.')),
      );
    }
  }

  Future<void> _sendMessage({String? content, String? imageUrl}) async {
    if ((content == null || content.trim().isEmpty) && imageUrl == null) return;

    try {
      final message = await _chatApi.sendMessage(
        chatId: widget.chatId,
        type: imageUrl != null ? 'image' : 'text',
        content: content ?? '',
        imageUrl: imageUrl,
      );
      setState(() {
        messages.add(message);
        if (content != null) _messageController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메시지 전송에 실패했습니다.')),
      );
    }
  }

  Future<void> _sendImage() async {
    try {
      final imageFile = await _imageApi.pickImage();
      if (imageFile != null) {
        final imageUrl = await _imageApi.uploadImage(
          imageFile,
          uploadType: 'chat',
          chatId: widget.chatId,
        );
        await _sendMessage(imageUrl: imageUrl); // 이미지 메시지 전송
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('채팅방')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final bool isMyMessage = message.senderId == currentUserId;

                return ListTile(
                  title: Align(
                    alignment: isMyMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isMyMessage ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: message.type == 'image' && message.imageUrl != null
                          ? Image.network(message.imageUrl!) // 이미지 메시지 표시
                          : Text(message.content),
                    ),
                  ),
                  subtitle: Align(
                    alignment: isMyMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      message.createdAt.toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: _sendImage, // 이미지 전송 버튼
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () =>
                      _sendMessage(content: _messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
