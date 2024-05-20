import 'package:flutter/material.dart';
import 'package:team_burumi/activity.dart';
import 'package:team_burumi/profile.dart';
import 'package:team_burumi/screens/chat_screen.dart';
import 'package:team_burumi/home2.dart';
import 'package:team_burumi/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List pages = [
    home2(),
    Activity(),
    ChatScreen(),
    LoginPage(),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'image/logo.png',
          width: 35,
          height: 35,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/alarm');
              },
              icon: Icon(Icons.notifications, color: Colors.black)),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 게시글 작성 버튼을 눌렀을 때 작업 수행
          // 여기에 게시글 작성 화면을 열거나 다른 작업을 수행하는 코드를 추가할 수 있습니다.
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _bottomNavigationBar(context),
    );
}
  Widget _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(color: Colors.black),
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.home),
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.text_snippet),
          ),
          label: '내 활동 보기',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.chat_bubble_outline),
          ),
          label: '채팅',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.person_outline),
          ),
          label: '내정보',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}

