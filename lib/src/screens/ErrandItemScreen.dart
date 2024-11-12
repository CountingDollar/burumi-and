import 'package:flutter/material.dart';
import 'package:team_burumi/src/models/ErrandGetModel.dart';
import 'package:team_burumi/src/screens/ApplyScreen.dart';
import 'package:intl/intl.dart';
import 'package:team_burumi/src/service/JWTapi.dart';
import 'ErrandListScreen.dart';

class PostItem extends StatelessWidget {
  final Delivery post;
  late final String formattedDate;
  late final String cost;
  late final String destination;
  late final String destinationDetail;
  late final String summary;
  late final String details;
  late final int ordererId;//추가
  final int category; // 카테고리 변수
  final List<String> categories;


  PostItem(
      {Key? key,
        required this.post,
        required this.category,
        required this.categories,
      })
      : super(key: key) {
    // 널 처리
    formattedDate = post.scheduledAt != null
        ? DateFormat('MM월 dd일').add_jm().format(post.scheduledAt!)
        : 'No Date';

    cost = post.cost ?? 'No cost';
    destination = post.destination ?? 'Unknown destination';
    destinationDetail = post.destinationDetail ?? 'No details';
    summary = post.summary ?? 'No summary';
    details = post.details ?? 'No details';
    ordererId = post.ordererId ?? -1;//추가
  }
  JwtApi _jwtApi=new JwtApi();

  String getCategoryName(int category) {
    if (category >= 0 && category <= categories.length) {
      return categories[category - 1]; // categoryId가 1부터 시작하므로 -1
    }
    return 'Unknown Category';
  }

  Widget buildStaticCategoryButton(String category) {
    final categoryColor = PostListScreen.categoryColors[category] ?? Colors.redAccent;

    return Container(
      padding: EdgeInsets.all(5), // 패딩 추가
      decoration: BoxDecoration(
        color: categoryColor,
        borderRadius: BorderRadius.circular(8), // 모서리 둥글게
        border: Border.all(color: Colors.grey), // 테두리 추가
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white, // 텍스트 색상
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String categoryName = getCategoryName(category);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "${cost} 원",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              buildStaticCategoryButton(categoryName),
              Text(
                destination,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              Text(
                destinationDetail,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                summary,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async{String? token = await _jwtApi.getToken();
                  if (token == null) {
                    Navigator.pushNamed(context, '/login');
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplyScreen(
                          summary: summary,
                          deadline: formattedDate ?? 'No deadline',
                          cost: cost.toString(),
                          content: details,
                          destination: destination,
                          destinationDetail: destinationDetail,
                          categoryColor: PostListScreen.categoryColors,
                          ordererId: ordererId,//추가
                        ),
                      ),
                    );
                  }
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


