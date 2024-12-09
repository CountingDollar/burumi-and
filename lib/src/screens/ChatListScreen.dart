import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_burumi/src/models/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:team_burumi/src/service/ApiService.dart';
import 'package:team_burumi/src/service/JwtApi.dart';
import 'ChatScreen.dart';
import '../service/ChatApi.dart';
import '../service/ErrandApi.dart';
import '../service/ApiService.dart';
import '../models/ErrandGetModel.dart';
import '../models/ChatModels.dart';

String formatTime(DateTime dateTime) {
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? '오후' : '오전';

  return '$period $hour:$minute';
}

Future<String> fetchPostTitle(int chatId) async {
  try {

    final response = await ApiService().dio.get('https://api.dev.burumi.kr/v1/chats/$chatId');

    if (response.data['code'] == 2000) {
      final messages = response.data['result']['messages'] as List<dynamic>;

      if (messages.isEmpty) {
        return "메시지가 없습니다";
      }


      final firstMessage = messages.last['content'] ?? '';
      print('첫 번째 메시지 content: $firstMessage');


      if (firstMessage.startsWith("POST_ID:")) {
        final postId = int.tryParse(firstMessage.split(":")[1] ?? '');
        if (postId == null) return "잘못된 POST_ID";

        final chatApi = ChatApi();
        final errandDetail = await chatApi.fetchErrandDetail(postId);

        // 게시글 제목 반환
        return errandDetail.summary ?? "제목 없음";
      } else {
        return "POST_ID 형식이 아님";
      }
    } else {
      return "API 오류: ${response.data['message']}"; // API 응답 실패
    }
  } catch (e) {
    print('fetchPostTitle 오류: $e');
    return "에러 발생: ${e.toString()}"; // 예외 발생 시
  }
}


class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isUserIdLoaded = false;
  final ChatApi chatApi = ChatApi();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print("탭 변경: ${_tabController.index}");
      setState(() {});
      print("탭 변경완료: ${_tabController.index}");
    });
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    try {
      // Step 1: 토큰 검증 및 사용자 ID 로드
      if (JwtApi.user1Id == null) {
        await JwtApi().verifyTokenAndSaveUserId();
      }

      // Step 2: ApiService 강제 호출로 초기화 트리거
      final apiService = ApiService();
      print('ApiService 강제 호출 완료');

      // 사용자 ID 로드 상태 업데이트
      setState(() {
        isUserIdLoaded = true;
      });
    } catch (e) {
      print('초기화 실패.: $e');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserIdLoaded || JwtApi.user1Id == null) {
      return Scaffold(
        appBar: AppBar(title: Text("채팅하기")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            "채팅하기",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                _buildEllipticalTabButton("요청", 0, Color(0xff542ABB)),
                SizedBox(width: 8),
                _buildEllipticalTabButton("지원", 1, Color(0xff542ABB)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ChatListView(isRequestTab: true, user1Id: JwtApi.user1Id!),
                ChatListView(isRequestTab: false, user1Id: JwtApi.user1Id!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEllipticalTabButton(String label, int tabIndex, Color color) {
    bool isSelected = _tabController.index == tabIndex;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(tabIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff542ABB) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ChatListView extends StatefulWidget {
  final bool isRequestTab;
  final int user1Id;
  ChatListView({required this.isRequestTab, required this.user1Id});

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final List<ChatOverview> chatRooms = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool hasError = false;
  final ApiService apiService = ApiService();
  final ChatApi chatApi = ChatApi();
  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms({int? user2Id, int page = 1, int size = 20}) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final queryParameters = {
        'user1_id': widget.user1Id.toString(),
        if (user2Id != null) 'user2_id': user2Id.toString(),
        'page': page.toString(),
        'size': size.toString(),
      };

      final response = await apiService.dio.get(
        'https://api.dev.burumi.kr/v1/chats',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final chatResponse = ChatOverviewResponse.fromJson(jsonResponse);
        setState(() {
          chatRooms.clear();
          chatRooms.addAll(chatResponse.chats);
        });
      } else {
        setState(() {
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(child: Text("채팅방을 가져오는 데 실패했습니다."));
    }

    return chatRooms.isEmpty
        ? Center(child: Text("현재 채팅방이 없습니다.", style: TextStyle(fontSize: 16, color: Colors.grey)))
        : ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(8.0),
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5, offset: Offset(0, 5))
              ],
            ),
            child: ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset("image/chaticon.svg", width: 40, height: 40),
                ],
              ),
              title: FutureBuilder<String>(
                future: fetchPostTitle(chatRoom.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("로딩 중...",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black));
                  } else if (snapshot.hasError) {
                    return Text("에러 발생",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red));
                  } else {
                    return Text(snapshot.data ?? "제목 없음",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black));
                  }
                },
              ),
              subtitle: FutureBuilder<MessageModel?>(
                future: chatApi.fetchLastMessage(chatRoom.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("로딩 중...",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]));
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Text("메시지 없음",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]));
                  } else {
                    return Text(snapshot.data!.content,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]));
                  }
                },
              ),
              trailing: FutureBuilder<MessageModel?>(
                future: chatApi.fetchLastMessage(chatRoom.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("...",
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]));
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Text("",
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]));
                  } else {
                    return Text(formatTime(snapshot.data!.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]));
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(chatId: chatRoom.id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}



