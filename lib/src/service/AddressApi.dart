import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class addressApi{
  final Dio _dio = Dio();

  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    const double step = 0.0001; // 이동할 거리의 단위 (약 10m)
    const int maxAttempts = 10; // 최대 시도 횟수

    for (int i = 0; i < maxAttempts; i++) {
      try {
        final response = await _dio.get(
          'https://dapi.kakao.com/v2/local/geo/coord2address.json',
          queryParameters: {
            'x': lng.toString(),
            'y': lat.toString(),
          },
          options: Options(headers: {
            'Authorization': 'KakaoAK ${dotenv.env['KAKAO_REST_API_KEY']}'
          }),
        );

        if (response.statusCode == 200) {
          final documents = response.data['documents'] as List;
          if (documents.isNotEmpty) {
            final roadAddress = documents[0]['road_address'];
            final address = documents[0]['address'];

            if (roadAddress == null) {
              // 도로명 주소가 없을 경우 좌표를 이동시키고 다음 반복으로 넘어감
              lat += step;
              lng += step;
              continue;
            }

            final addressName = roadAddress['address_name'];
            final buildingName = roadAddress['building_name'];
            print(i);
            // 주소와 건물 이름을 결합하여 반환
            return buildingName != null
                ? '$addressName, $buildingName'
                : addressName;
          }
        } else {
          print('API 호출 실패.: ${response.statusCode}');
        }
      }catch (e) {
        print('주소 찾기 오류 발생: $e');
      }

    }

    return null; // 최종적으로 도로명주소를 찾지 못했을 경우 null 반환
  }
}


