import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../providers/Styles.dart';
import '../service/JWTapi.dart';
import '../service/ChatApi.dart';
import 'ChatScreen.dart';
import '../Service/ErrandApi.dart';

class ApplyScreen extends StatelessWidget {
  final String summary;
  final String cost;
  final String deadline;
  final String content;
  final String destination;
  final String destinationDetail;
  final Map<String, Color> categoryColor;
  final int ordererId;
  final int errandId;

  const ApplyScreen(
      {Key? key,
        required this.summary,
        required this.cost,
        required this.deadline,
        required this.content,
        required this.destination,
        required this.destinationDetail,
        required this.categoryColor,
        required this.ordererId,
        required this.errandId,
      })
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
            Text(
              destinationDetail,
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
                            Text('$cost 원',
                                style:
                                TextStyle(fontSize: 18, color: Colors.red)),
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
                    padding: const EdgeInsets.fromLTRB(8, 3, 40, 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('마감기한', style: TextStyle(fontSize: 18)),
                              AutoSizeText('$deadline',
                                  minFontSize: 9, maxLines: 2),
                            ],
                          ),
                        )
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
                      backgroundColor: buttonBackgroundColor),
                  onPressed: () {
                    _applyAndCreateChat(context);
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
  Future<void> _applyAndCreateChat(BuildContext context) async {
    try {

      final errandApi = errandsApi();
      await errandApi.applyForErrand(errandId);
      print('심부름 지원 성공');


      final user1Id = await JwtApi().getUser1Id();
      if (user1Id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 ID를 확인할 수 없습니다. 다시 로그인 해주세요.')),
        );
        return;
      }

      final chatApi = ChatApi();
      final chat = await chatApi.createChat(user1Id: user1Id, user2Id: ordererId, errandId: errandId);
      print('채팅방 생성 성공: ${chat.id}');



      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(chatId: chat.id)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('지원 실패: $e')),
      );
    }
  }
}







