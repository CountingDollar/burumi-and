import 'package:team_burumi/src/models/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:team_burumi/src/service/ApiService.dart';
import 'package:team_burumi/src/service/JwtApi.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isUserIdLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    if (JwtApi.user1Id == null) {
      await JwtApi().verifyTokenAndSaveUserId();
    }
    setState(() {
      isUserIdLoaded = true;
    });
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
                _buildEllipticalTabButton("요청", 0, Colors.blueAccent),
                SizedBox(width: 8),
                _buildEllipticalTabButton("지원", 1, Colors.greenAccent),
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
          color: isSelected ? color : Colors.grey[300],
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
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: widget.isRequestTab ? Colors.blueAccent : Colors.greenAccent,
                  ),
                  Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
                ],
              ),
              title: Text(chatRoom.id.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
              subtitle: Text("마지막 메시지 내용 표시",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              trailing: Text("오후 3:45",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              onTap: () {
                // Navigate to chat room (detailed chat view)
              },
            ),
          ),
        );
      },
    );
  }
}


