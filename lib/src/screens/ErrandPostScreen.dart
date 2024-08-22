import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../providers/Styles.dart';
import 'AdressScreen.dart';

class ErrandScreen extends StatefulWidget {
  @override
  _ErrandScreenState createState() => _ErrandScreenState();
}

class _ErrandScreenState extends State<ErrandScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailedAddressController =
      TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isAddressSelected = false;

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
              SizedBox(height: 30),
              Text('거래희망 장소', style: errandPostTextStyle),
              AddressText(),
              CurrentLocationButton(),
              SizedBox(height: 20),
              Text(
                '제목',
                style: errandPostTextStyle,
              ),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  hintText: '심부름 내용 요약',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('심부름 비용', style: errandPostTextStyle),
              SizedBox(height: 10,),
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
                style: errandPostTextStyle,
              ),
              SizedBox(height: 10,),
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
                style:errandPostTextStyle
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '게시글 내용을 작성해 주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 게시하기 버튼 클릭 시의 동작
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(350, 50),
                    backgroundColor: buttonBackgroundColor,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    '게시하기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGoogleMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CustomGoogleMap(address: _addressController.text)),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _isAddressSelected = true;
        _addressController.text = result['fullAddress'] ?? '';
        _detailedAddressController.text = result['detailAddress'] ?? '';
      });
    }
  }

  Widget AddressText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: '주소 검색',
          ),
          onTap: () {
            // HapticFeedback.mediumImpact();
            _addressAPI(); // 카카오 주소 API 호출
          },
        ),
        if (_isAddressSelected)
          Column(
            children: [
              TextField(
                controller: _detailedAddressController,
                decoration: InputDecoration(
                  labelText: '상세 주소',
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget CurrentLocationButton() {
    return TextButton(
      onPressed: () {
        _navigateToGoogleMap(); // 구글 맵으로 이동
      },
      child: Text('현재위치로 설정', style: TextStyle(color: Colors.black)),
    );
  }

  _addressAPI() async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    setState(() {
      _isAddressSelected = true;
      _addressController.text = ' ${model.address} ';
    });
  }
}
