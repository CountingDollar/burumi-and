import 'package:flutter/material.dart';
import 'package:team_burumi/src/screens/activity.dart';
import 'package:team_burumi/src/screens/info.dart';
import 'package:team_burumi/src/screens/chat_screen.dart';
import 'package:team_burumi/src/screens/login.dart';
import 'package:team_burumi/src/providers/app_labels.dart';
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

class Post {
  final String title;
  final String category;
  final int cost;
  final String deadline;
  final String post;
  Post({required this.title, required this.category,required this.cost
  ,required this.deadline,required this.post});
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
    Post(title: 'Post 1', category: '서류배달', cost:1000,deadline:'10/1',post:'테스트1'),
    Post(title: 'Post 2', category: '물건배달', cost:1001,deadline:'10/2',post:'테스트2'),
    Post(title: 'Post 3', category: '음식배달', cost:1002,deadline:'10/3',post:'테스트3'),
    Post(title: 'Post 4', category: '기타', cost:1003,deadline:'10/4',post:'테스트4'),
    Post(title: 'Post 5', category: '물건배달', cost:1004,deadline:'10/5',post:'테스트5'),
  ];

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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, ),
              ),
              SizedBox(width: 10),
              // 카테고리 버튼들: _categories 리스트의 각 항목을 버튼으로 변환하여 표시합니다.
              ..._categories.map((category) {
                return SizedBox(
                  width: 82,
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
          // 이미 선택된 카테고리를 다시 누르면 선택을 해제합니다.
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/errand');
          // 게시글 작성 버튼을 눌렀을 때 작업 수행
          // 여기에 게시글 작성 화면을 열거나 다른 작업을 수행하는 코드를 추가할 수 있습니다.
        },
        child: Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          // 내 페이지로 이동
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
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => applyPage(
                      title: post.title,
                      deadline: post.deadline,
                      cost: post.cost,
                      content: post.post,
                    ),
                  ),
                );
              },
              child: Text('지원'),
            ),
          ),
        ],
      ),
    );
  }
}
class applyPage extends StatelessWidget {


  final String title;
  final int cost;
  final String deadline;
  final String content;

  const applyPage({
    Key? key,
    required this.title,
    required this.cost,
    required this.deadline,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('심부름 비용: ${cost}원', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(width: 8), // 간격 조절
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('마감기한: $deadline', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Text(
              '상세내용',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(content, style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
    ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 색상
                ),
                onPressed: () {
                  // 지원하기 버튼 눌렀을 때 동작
                },
                child: Text('지원하기', style: TextStyle(fontSize: 18,color:Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}