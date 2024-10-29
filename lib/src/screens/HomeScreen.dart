import 'package:flutter/material.dart';
import 'package:team_burumi/src/screens/activity.dart';
import 'package:team_burumi/src/screens/chat_screen.dart';
import 'package:team_burumi/src/screens/MyPageScreen.dart';
import 'package:team_burumi/src/providers/AppLabels.dart';
import '../providers/Styles.dart';
import '../service/JWTapi.dart';
import 'ErrandListScreen.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  JwtApi jwtApi = new JwtApi();
  List<Widget> pages = [
    PostListScreen(),
    Activity(),
    ChatScreen(),
    MyPage(),
  ];

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
              onPressed: () async{
                String? token = await jwtApi.getToken();
                if (token == null) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.pushNamed(context, '/alarm');
                }
              },
              icon: Icon(Icons.notifications, color: Colors.black)),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple, // 네비게이션 바 배경색
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), // 위쪽 왼쪽 모서리 둥글게
            topRight: Radius.circular(30.0), // 위쪽 오른쪽 모서리 둥글게
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상
              spreadRadius: 5, // 그림자 확산 범위
              blurRadius: 10, // 그림자 흐림 정도
              offset: Offset(0, 4), // 그림자 위치
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: _bottomNavigationBar(context),
        ),
      ),
    );
  }

  Future<void> _handleNavigation(int index) async {
    final JwtApi jwtApi = JwtApi();
    String? token = await jwtApi.getToken();
    print('Selected index: $index, Token: $token');
    if (_selectedIndex == index) return;

    if (token != null) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: buttonBackgroundColor,
      selectedLabelStyle: TextStyle(color: buttonBackgroundColor),
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: TextStyle(color: Colors.black),
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
      currentIndex: _selectedIndex,
      onTap: (int index) {
        _handleNavigation(index);
      },
    );
  }
}


