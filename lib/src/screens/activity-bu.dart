import 'package:flutter/material.dart';
import '../models/ErrandGetModel.dart';
import '../service/ApiService.dart';
import '../service/JWTapi.dart';

class ActivityBu extends StatelessWidget {
  const ActivityBu({Key? key}) : super(key: key);


  Future<List<Delivery>> fetchMyCreatedErrands({int page = 1, int size = 20}) async {
    final userId = await JwtApi().getUser1Id();
    if (userId == null) throw Exception('사용자 ID를 확인할 수 없습니다.');

    final dio = ApiService().dio;
    final url = 'https://api.dev.burumi.kr/v1/users/$userId/errands';

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'filter': 'orderer',
          'page': page,
          'size': size,
        },
      );

      // 성공 코드 확인
      if (response.data['code'] != 2000) {
        throw Exception('심부름 데이터를 불러오는 데 실패했습니다: ${response.data}');
      }

      // 응답 데이터 파싱
      final rows = response.data['result']['rows'] as List<dynamic>;

      // Delivery 모델로 매핑
      return rows.map((row) => Delivery.fromJson(row)).toList();
    } catch (e) {
      throw Exception('심부름 데이터를 가져오는 중 오류 발생: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Delivery>>(
      future: fetchMyCreatedErrands(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('작성한 게시글이 없습니다.'));
        } else {
          final errands = snapshot.data!;
          return ListView.builder(
            itemCount: errands.length,
            itemBuilder: (context, index) {
              final errand = errands[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                    errand.summary ?? '제목 없음',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(errand.destination ?? '목적지 없음'),
                      const SizedBox(height: 4),
                      Text('비용: ${errand.cost ?? '정보 없음'}원'),
                    ],
                  ),
                  trailing: errand.messengerId != null
                      ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/applicantList', arguments: errand.id);
                    },
                    child: const Text('지원자 보기'),
                  )
                      : null,
                ),
              );
            },
          );
        }
      },
    );
  }
}
