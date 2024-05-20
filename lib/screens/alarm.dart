import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:team_burumi/models/modelalarm.dart';
import 'package:team_burumi/providers/http_status_codes.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<User> users = []; // User 모델의 리스트로 변경
  RefreshController _activityRefreshController = RefreshController(initialRefresh: false);
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchUsers(); // 사용자 정보를 가져오는 함수 호출
  }

  void _onRefresh() async {
    await fetchUsers(); // 새로 고침 시 사용자 정보 다시 가져오기
    _refreshController.refreshCompleted();
    _activityRefreshController.refreshCompleted();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == HttpStatusCodes.ok) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        // API에서 가져온 데이터를 User 모델로 변환하여 users 리스트에 추가
        users = data.map((item) => User.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('알림'),
          bottom: TabBar(
            tabs: [
              Tab(text: '공지'),
              Tab(text: '활동'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationTab(users: users, onRefresh: _onRefresh, refreshController: _refreshController),
            ActivityTab(users: users, onRefresh: _onRefresh, refreshController: _activityRefreshController),
          ],
        ),
      ),
    );
  }
}

class NotificationTab extends StatelessWidget {
  final List<User> users;
  final RefreshController refreshController;
  final VoidCallback onRefresh;

  const NotificationTab(
      {Key? key, required this.users, required this.refreshController, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      // 아래로 당겨 새로고침 기능 활성화 여부
      header: WaterDropHeader(),
      // 아래로 당겨 새로고침 시 보여줄 헤더 위젯 설정
      controller: refreshController,
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: users.isEmpty ? 0 : users.length * 2 - 1,
        // 사용자 목록이 비어있으면 0을 반환하고, 아니면 사용자 수의 두 배에서 하나를 뺀 값을 반환합니다.
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return Divider();
          } else {
            final userIndex = index ~/ 2; // 실제 사용자 인덱스 계산
            final user = users[userIndex];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  user.title, // 사용자의 제목 표시
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  'ID: ${user.id}',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ActivityTab extends StatelessWidget {
  final List<User> users;
  final RefreshController refreshController;
  final VoidCallback onRefresh;

  const ActivityTab({Key? key, required this.users, required this.refreshController, required this.onRefresh})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: refreshController,
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: users.isEmpty ? 0 : users.length * 2 - 1,
        // 사용자 목록이 비어있으면 0을 반환하고, 아니면 사용자 수의 두 배에서 하나를 뺀 값을 반환합니다.
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return Divider();
          } else {
            final userIndex = index ~/ 2;
            final user = users[userIndex];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(
                  user.body,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  'ID: ${user.userId}', // id를 subtitle로 사용
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
