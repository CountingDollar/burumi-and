import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class ErrandScreen extends StatefulWidget {
  @override
  _ErrandScreenState createState() => _ErrandScreenState();
}

class _ErrandScreenState extends State<ErrandScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _categories = ['서류배달', '물건배달', '음식배달', '기타'];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('심부름 맡기기'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '거래희망 장소',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              AddressText(),
              SizedBox(height: 16),
              Text(
                '카테고리 선택',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildCategoryButton(category),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text(
                '제목',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: '심부름 내용 요약',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '심부름 비용',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '가격',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '마감 기한',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _deadlineController,
                decoration: InputDecoration(
                  hintText: '마감 기한',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '자세한 설명',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '게시글 내용을 작성해 주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 게시하기 버튼 클릭 시의 동작
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 50),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text('게시하기'),
                ),
              ),
            ],
          ),
        ),
      ),
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
        backgroundColor: isSelected ? Colors.purple : Colors.white38,
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget AddressText() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(); // 카카오 주소 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              hintText: '도로명, 건물명으로 검색',
              isDense: false,
              border: OutlineInputBorder(),
            ),
            controller: _addressController,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  _addressAPI() async {
    // 주소 검색 페이지로 이동
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    setState(() {
      _addressController.text =
      '${model.zonecode} ${model.address }${model.buildingName }  ';
    });
    // 상세주소 입력 페이지로 이동하고 결과를 받음
    final detailedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedAddressInputPage(
          address: _addressController.text,
        ),
      ),
    );

    // 상세주소 포함한 전체 주소를 텍스트 필드에 설정
    if (detailedAddress != null) {
      _addressController.text = detailedAddress;
    }
  }


}

  class DetailedAddressInputPage extends StatelessWidget {
  final String address;
  final TextEditingController _detailedAddressController = TextEditingController();

  DetailedAddressInputPage({required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세 주소 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '선택한 주소: $address',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: '상세 주소를 입력하세요',
                isDense: false,
                border: OutlineInputBorder(),
              ),
              controller: _detailedAddressController,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 상세 주소 저장 후 원하는 동작 수행
                String fullAddress = '$address ${_detailedAddressController.text}';
                print('전체 주소: $fullAddress');
                Navigator.pop(context, fullAddress);
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
// class KakaoMapExample extends StatefulWidget {
//   @override
//   _KakaoMapExampleState createState() => _KakaoMapExampleState();
// }
//
// class _KakaoMapExampleState extends State<KakaoMapExample> {
//   late KakaoMapController _mapController;
//   final TextEditingController _addressController = TextEditingController();
//
//   void _onMapCreated(KakaoMapController controller) {
//     _mapController = controller;
//   }
//
//   void _setAddress() async {
//     final result = await _mapController.searchAddress('서울특별시 강남구 테헤란로 427');
//     if (result != null && result.isNotEmpty) {
//       final address = result.first;
//       _mapController.moveCamera(CameraUpdate.toLatLng(LatLng(address.y, address.x)));
//       _mapController.addMarker(MarkerOptions(
//         position: LatLng(address.y, address.x),
//         title: '검색한 주소',
//         snippet: address.addressName,
//         onTap: () {
//           _addressController.text = address.addressName;
//         },
//       ));
//     }
//   }
//
//   void _onMarkerTapped(LatLng position) async {
//     final result = await _mapController.getAddressFromCoord(position.latitude, position.longitude);
//     if (result != null && result.isNotEmpty) {
//       final address = result.first;
//       setState(() {
//         _addressController.text = address.addressName;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Kakao Map Example'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: KakaoMapView(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(37.5665, 126.9780),
//                 zoom: 10,
//               ),
//               onTap: (LatLng position) {
//                 _mapController.addMarker(MarkerOptions(
//                   position: position,
//                   title: '클릭한 위치',
//                   onTap: () => _onMarkerTapped(position),
//                 ));
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText: 'Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _setAddress,
//             child: Text('주소 설정'),
//           ),
//         ],
//       ),
//     );
//   }
// }