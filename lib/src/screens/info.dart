import 'package:flutter/material.dart';
import 'package:team_burumi/src/providers/app_labels.dart';


class profile extends StatelessWidget {
  const profile ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
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
          label: AppLabels.home,
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.text_snippet),
          ),
          label: AppLabels.activity,
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.chat_bubble_outline),
          ),
          label: AppLabels.chat,
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.person_outline),
          ),
          label: AppLabels.info,
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
            Navigator.pushNamed(context, '/info');
            break;
        }
      },

    );
  }
}
