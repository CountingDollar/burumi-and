import 'package:flutter/material.dart';
import 'package:team_burumi/src/screens/activity.dart';
import 'package:team_burumi/src/screens/chat_screen.dart';
import 'package:team_burumi/src/screens/MyPageScreen.dart';
import 'package:team_burumi/src/providers/AppLabels.dart';
import 'package:team_burumi/src/models/ErrandGetModel.dart';
import 'package:team_burumi/src/service/ErrandApi.dart';

import '../providers/Styles.dart';
import '../service/JWTapi.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    home2(),
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
              onPressed: () {
                Navigator.pushNamed(context, '/alarm');
              },
              icon: Icon(Icons.notifications, color: Colors.black)),
        ],
        // shape: Border(
        //   bottom: BorderSide(
        //     color: Colors.grey,
        //     width: 1,
        //   ),
        // ),
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

class home2 extends StatefulWidget {
  home2({Key? key}) : super(key: key);

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<home2> {
  JwtApi jwtApi = new JwtApi();
  String? _selectedCategory;
  List<String> _categories = ['서류배달', '물건배달', '음식배달', '기타']; // 카테고리 목록
  final errandsApi _errandlist = errandsApi();
  String _selectedSortOption = '최신순';
  final List<String> _sortOptions = ['최신순', '오래된 순'];
  List<Post> _posts = [];
  bool _isLoading = false;
  late int _totalOrderers = 0;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts({int page = 1, int size = 20}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await _errandlist.fetchPosts(page: page, size: size);
      setState(() {
        _posts = posts;
        _isLoading = false;
        _totalOrderers = posts.length; // Or adjust according to your needs
      });
      print('Posts loaded: $_posts');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error appropriately
      print('Failed to load posts: $e');
    }
  }

  Widget _body() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "카테고리",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _categories.map((category) {
                        return SizedBox(
                          child: _buildCategoryButton(category),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 0.7,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '전체 건수: $_totalOrderers건',
                      style: TextStyle(fontSize: 14),
                    ),
                    Spacer(),
                    Container(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('정렬: ', style: TextStyle(fontSize: 14)),
                          DropdownButton<String>(
                            value: _selectedSortOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSortOption = newValue!;
                              });
                            },
                            items: _sortOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:
                                    Text(value, style: TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            isDense: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildPostList(),
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
        backgroundColor: _selectedCategory == category
            ? Colors.purple
            : Colors.white38,
      ),
      child: Text(
        category,
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: _selectedCategory == category
                ? Colors.white
                : Colors.white), // 텍스트의 글자색 조절
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return PostItem(post: post);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          String? token = await jwtApi.getToken();
          if (token == null) {
            Navigator.pushNamed(context, '/login');
          } else {
            Navigator.pushNamed(context, '/errand');
          }
        },
        backgroundColor: buttonBackgroundColor,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text("${post.cost} 원"),
              ),
              Text(
                post.destination,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              Text(
                post.destinationDetail,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                post.summary,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplyPage(
                          summary: post.summary,
                          deadline: post.scheduledAt ?? 'No deadline',
                          cost: post.cost.toString(),
                          content: post.details,
                          destination: post.destinationDetail,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Container(
                    width: 50,
                    // 버튼의 너비 설정
                    height: 30,
                    // 버튼의 높이 설정
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    // 컨테이너 내부의 좌우 패딩 조정
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, color: Colors.blue, size: 15),
                        // 종이비행기 아이콘 추가 및 크기 조절
                        SizedBox(width: 5),
                        // 아이콘과 텍스트 사이의 간격 최소화
                        Text('지원',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}

class ApplyPage extends StatelessWidget {
  final String summary;
  final String cost;
  final String deadline;
  final String content;
  final String destination;

  const ApplyPage(
      {Key? key,
      required this.summary,
      required this.cost,
      required this.deadline,
      required this.content,
      required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              summary,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Text(
              destination,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w100,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.grey),
                        SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('심부름 비용', style: TextStyle(fontSize: 18)),
                            Text('$cost 원', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16), // 간격 조절
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('마감기한', style: TextStyle(fontSize: 18)),
                            Text('$deadline', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 30),
            Text(
              '상세내용',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    width: double.infinity,
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
            SizedBox(height: 25),
            Center(
              child: Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor
                      ),
                  onPressed: () {
                    // 지원하기 버튼 눌렀을 때 동작
                  },
                  child: Text(
                    '지원하기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
