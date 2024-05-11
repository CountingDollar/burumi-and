import 'package:flutter/material.dart';



class profile extends StatelessWidget {
  const profile ({super.key});

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
              onPressed: () {},
              icon: Icon(Icons.notifications, color: Colors.black)),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: _body(context),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }
  Widget _body(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
        },
        child: Text('로그아웃'),
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context,) {
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
      onTap: (index) {
        switch (index) {
          case 0:
          // 홈 페이지로 이동
            Navigator.pushNamed(context, '/home2');
            break;
          case 1:
          // 내 활동 보기 페이지로 이동
            Navigator.pushNamed(context, '/activity');
            break;
          case 2:
          // 채팅 페이지로 이동
            Navigator.pushNamed(context, '/chat');
            break;
          case 3:
          // 내 정보 페이지로 이동
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },

    );
  }
}
