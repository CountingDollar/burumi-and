import 'package:flutter/material.dart';
import 'package:team_burumi/src/models/ErrandGetModel.dart';
import 'package:team_burumi/src/service/CategoryApi.dart';
import 'package:team_burumi/src/service/ErrandApi.dart';
import '../providers/Styles.dart';
import '../service/JWTapi.dart';
import 'ErrandItemScreen.dart';


class PostListScreen extends StatefulWidget {
  PostListScreen({Key? key}) : super(key: key);

  @override
  _Postlist2State createState() => _Postlist2State();
  // static final List<String> categories = ['서류배달', '물건배달', '음식배달', '기타'];

  // static final List<String> categories =response.data['result']['name'];
  static final Map<String, Color> categoryColors = {
    '서류배달': Colors.red,
    '물건배달': Colors.orange,
    '음식배달': Colors.yellow,
    '기타': Colors.green
  };


}

class _Postlist2State extends State<PostListScreen> {
  JwtApi jwtApi = new JwtApi();
  int? _selectedCategory;
  final errandsApi _errandlist = errandsApi();
  String _selectedSortOption = '최신순';
  final List<String> _sortOptions = ['최신순', '오래된 순'];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final CategoryApi _categoryApi= new CategoryApi();

  late int _totalOrderers = 0;
  int currentPage = 1;
  int pageSize = 4; // 한 페이지에 표시할 게시물 수
  List<Delivery> _displayedPosts = []; // 현재 페이지에 표시할 게시물 목록
  List<Delivery>_allPosts=[];

  int get totalPageCount {
    return (_totalOrderers > 0) ? (_totalOrderers / pageSize).ceil() : 1;
  }
  @override
  void initState() {
    super.initState();
    loadPosts(page: currentPage);
    fetchAllPosts();
    _loadCategories();
  }
  List<String> categories = [];
  Future<void> _loadCategories() async {
    try {
      final response = await _categoryApi.getCategory();
      // response.data['result']를 List<dynamic>으로 할당
      // final List<dynamic> result = response.data['result'];
      // result를 String 리스트로 변환
      final List<String> fetchedCategories = response.map((item) => item['name'].toString()).toList();

      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print("Error loading categories: $e");
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
// 전체 게시물을 한 번에 가져와 allPosts에 저장하는 함수
  Future<void> fetchAllPosts() async {
    try {
      var response = await _errandlist.fetchPosts(); // 모든 게시물을 불러오는 API 호출
      List<Delivery> posts = response['errands'];
      setState(() {
        _allPosts = posts; // 전체 게시물 업데이트
      });
    } catch (e) {
      print("Error fetching all posts: $e");
    }
  }
  // 현재 페이지의 데이터를 불러오는 함수
  Future<void> loadPosts({int page = 1}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await _errandlist.fetchPosts(page: page, size: pageSize);
      List<Delivery> posts = response['errands'];
      int count = response['count'];

      setState((){
        print("Selected Category: $_selectedCategory");
        _displayedPosts = (_selectedCategory == null)
            ? posts
            : _allPosts.where((post) {
          print("Post Category ID: ${post.category_id}, Selected: ${_selectedCategory! + 1}");
          return post.category_id == _selectedCategory! + 1;
        }).toList();

        currentPage = page; // 현재 페이지 업데이트
        _isLoading = false;
        _totalOrderers = count;
      });
    } catch (e) {
      print("page error: $e");
    }
  }

  Widget _buildPageButtons() {
    List<Widget> pageButtons = [];

    // "이전" 버튼
    if (currentPage > 1) {
      pageButtons.add(
        TextButton(
          onPressed: () {
            setState(() {
              currentPage--;
              loadPosts(page: currentPage);
            });
          },
          child: Text('이전'),
        ),
      );
    }
    int startPage = (currentPage - 1) > 0 ? (currentPage - 1) : 1;
    int endPage = (currentPage + 1) <= totalPageCount
        ? (currentPage + 1)
        : totalPageCount;

    // 페이지 번호 버튼 추가
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        TextButton(
          onPressed: () {
            setState(() {
              currentPage = i;
              loadPosts(page: i); // 해당 페이지 데이터 불러오기
            });
          },
          child: Text(
            '$i',
            style: TextStyle(
              color: i == currentPage ? Colors.deepPurple : Colors.grey,
              fontWeight: i == currentPage
                  ? FontWeight.w900
                  : FontWeight.normal, // 선택된 페이지 텍스트 색상
            ),
          ),
        ),
      );
    }

    // "다음" 버튼
    if (currentPage < totalPageCount) {
      pageButtons.add(
        TextButton(
          onPressed: () {
            setState(() {
              currentPage++;
              loadPosts(page: currentPage);
            });
          },
          child: Text('다음'),
        ),
      );
    }

    // 페이지 버튼을 가로로 나열하는 위젯 반환
    return Wrap(
      spacing: 8.0, // 버튼 간 간격
      alignment: WrapAlignment.center,
      children: pageButtons,
    );
  }

  // 카테고리 버튼 선택 시 호출되는 함수
  void _updateDisplayedPostsByCategory() {
    setState(() {
      _displayedPosts = (_selectedCategory == null)
          ? _allPosts // 모든 게시물을 가져오거나
          : _allPosts.where((post) => post.category_id == _selectedCategory! + 1).toList(); // 선택된 카테고리 게시물 가져오기

      // _sortPosts(); // 현재 정렬 옵션에 따라 정렬 적용
    });
  }
  // 정렬 옵션 변경 시 호출되는 함수
  // void _sortPosts() {
  //   setState(() {
  //     if (_selectedSortOption == '최신순') {
  //       _displayedPosts.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
  //
  //     } else if (_selectedSortOption == '오래된 순') {
  //       _displayedPosts.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
  //
  //     }
  //   });
  // }

  Widget _body() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
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
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                        child: Row(
                          // Wrap 대신 Row 사용
                            children:categories.asMap().entries.map((entry) {
                              int index = entry.key; // 리스트의 인덱스
                              String category = entry.value; // 리스트의 항목 값

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: SizedBox(
                                  height: 30,
                                  width: 60,
                                  child: buildCategoryButton(category, index),
                                ),
                              );
                            }).toList()
                        ),
                      ),
                    )
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
                                // _sortPosts();
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
                : _buildPostList()),
        _buildPageButtons()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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

  Widget buildCategoryButton(String category, int index) {
    final isSelected = _selectedCategory == index;
    final categoryColor = PostListScreen.categoryColors[category] ?? Colors.grey;

    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = (constraints.maxWidth / 4) - 10; // 버튼 너비 조정 (화면 너비의 1/3)
        double buttonHeight = buttonWidth * 0.5; // 버튼 높이 조정 (너비의 60%)

        return ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedCategory = isSelected ? null : index;
              _updateDisplayedPostsByCategory();
            });
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(buttonWidth, buttonHeight),
            padding: EdgeInsets.zero,
            backgroundColor: isSelected ? categoryColor : Colors.white38,
          ),
          child: Text(
            category,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        );
      },
    );
  }

  Future<void> _refreshPosts() async {
    await loadPosts(page: 1); // 새로고침 시 첫 페이지 데이터 불러오기
  }

  Widget _buildPostList() {
    return RefreshIndicator(
      onRefresh: _refreshPosts, // 새로고침 동작 추가
      child: ListView.builder(
        controller: _scrollController, // ScrollController 연결
        itemCount: _displayedPosts.length, // 필터링된 게시물 수
        itemBuilder: (context, index) {
          final post = _displayedPosts[index];
          return PostItem(
            post: post,
            category: post.category_id ?? -1,
            categories:categories,
          );
        },
      ),
    );
  }
}