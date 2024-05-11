import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class Post {
  final String title;
  final String category;

  Post({required this.title, required this.category});
}

class home2 extends StatefulWidget {
  const home2({Key? key}) : super(key: key);

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<home2> {
  String? _selectedCategory;
  List<String> _categories = ['서류배달', '물건배달', '음식배달', '기타']; // 카테고리 목록
  // 가짜 데이터
  final List<Post> _posts = [
    Post(title: 'Post 1', category: '서류배달'),
    Post(title: 'Post 2', category: '물건배달'),
    Post(title: 'Post 3', category: '음식배달'),
    Post(title: 'Post 4', category: '기타'),
    Post(title: 'Post 5', category: '물건배달'),
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
      body: _body(),
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

  Widget _body() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "카테고리",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, ), // 텍스트의 크기 조절
              ),
              SizedBox(width: 10), // 텍스트와 버튼 사이의 간격 조절
              ..._categories.map((category) {
                return SizedBox(
                  width: 82, // 버튼의 너비를 조절할 수 있습니다.
                  child: _buildCategoryButton(category),
                );
              }).toList(),
            ],
          ),
        ),
        Expanded(
          child: _buildPostList(),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = _selectedCategory == category;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = isSelected ? null : category;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: _selectedCategory == category ? Colors.purple : Colors.white38, // 버튼의 배경색 조절
      ),
      child: Text(
        category,
        style: TextStyle(fontSize:12, fontWeight: FontWeight.bold, color: _selectedCategory == category ? Colors.white : Colors.white), // 텍스트의 글자색 조절
      ),
    );
  }


  Widget _buildPostList() {
    // _selectedCategory가 null이거나 빈 문자열인 경우 모든 게시물을 보여줌
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      return ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return _PostItem(post: post);
        },
      );
    } else {
      // 선택된 카테고리에 해당하는 게시물만 보여줌
      final filteredPosts = _posts.where((post) => post.category == _selectedCategory).toList();
      return ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return _PostItem(post: post);
        },
      );
    }
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
      onTap: (index) {
        switch (index) {
          case 0:
            // 홈 페이지로 이동
            Navigator.pushNamed(context, '/home');
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
            Navigator.pushNamed(context, '/login');
            break;
        }
      },
    );
  }
}


class _PostItem extends StatelessWidget {
  final Post post;

  _PostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title),
          Text(post.category),
          // SizedBox(
          //   height: 200,
          //   child: NaverMap(
          //     initialCameraPosition: CameraPosition(
          //       target: LatLng(37.5665, 126.9780),
          //       zoom: 14,
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                // 버튼을 눌렀을 때 수행할 작업 추가
              },
              child: Text('버튼'),
            ),
          ),
        ],
      ),
    );
  }
}