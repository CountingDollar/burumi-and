import 'package:flutter/material.dart';
import '../models/ErrandGetModel.dart';
import '../service/ErrandApi.dart';
import '../service/JWTapi.dart';

class ActivityBu extends StatelessWidget {
  const ActivityBu({Key? key}) : super(key: key);

  Future<List<Delivery>> fetchMyCreatedErrands() async {
    final userId = await JwtApi().getUser1Id();
    if (userId == null) throw Exception('사용자 ID를 확인할 수 없습니다.');
    final errandsData = await errandsApi().fetchPosts();
    final errands = errandsData['errands'] as List<Delivery>;
    return errands.where((e) => e.ordererId == userId).toList();
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
