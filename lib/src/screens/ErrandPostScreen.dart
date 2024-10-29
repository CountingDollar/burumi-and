import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:team_burumi/src/screens/ErrandListScreen.dart';
import '../providers/Styles.dart';
import '../service/CategoryApi.dart';
import '../service/ErrandApi.dart';
import 'AdressScreen.dart';

class ErrandScreen extends StatefulWidget {
  @override
  _ErrandScreenState createState() => _ErrandScreenState();
}

class _ErrandScreenState extends State<ErrandScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailedAddressController =
      TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  bool _isAddressSelected = false;
  int? _selectedCategory;
  final CategoryApi _categoryApi= new CategoryApi();
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await _categoryApi.getCategory();
      final List<String> fetchedCategories = response.map((item) => item['name'].toString()).toList();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print("Error loading categories: $e");
    }
  }
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
                '카테고리 선택',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: categories
                    .asMap()
                    .entries
                    .map((entry) => buildCategoryButton(entry.value, entry.key))
                    .toList(),
              ),
              SizedBox(height: 20),
              Text(
                '제목',
                style: errandPostTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _summaryController,
                decoration: InputDecoration(
                  hintText: '심부름 내용 요약',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('심부름 비용', style: errandPostTextStyle),
              SizedBox(
                height: 10,
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
                style: errandPostTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _deadlineController,
                decoration: InputDecoration(
                  hintText: '마감 기한',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // 사용자가 직접 입력할 수 없게 설정
                onTap: () {
                  // 텍스트 필드를 클릭했을 때 시간 선택기를 보여줌
                  _selectDateTime(context);
                },
              ),
              SizedBox(height: 16),
              Text('자세한 설명', style: errandPostTextStyle),
              SizedBox(
                height: 10,
              ),
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
                  onPressed: () async {
                    errandsApi errandsService = errandsApi();
                    await errandsService.createErrand(
                      context: context,
                      destination: _addressController.text,
                      destinationDetail: _detailedAddressController.text,
                      cost: _costController.text,
                      summary: _summaryController.text,
                      details: _descriptionController.text,
                      categoryId: _categoryIdController.text,
                      scheduledAt: _deadlineController.text,
                    );
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

  // 날짜 선택 함수
  Future<void> _selectDateTime(BuildContext context) async {
    // 날짜 선택기 표시
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // 시간이 선택된 경우에 시간 선택기를 표시
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // 선택된 날짜와 시간을 합쳐서 표시
        final DateTime dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          // DateTime 객체를 원하는 형식으로 변환하여 텍스트 필드에 표시
          _deadlineController.text = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
              "${pickedTime.format(context)}";
        });
      }
    }
  }

  Widget buildCategoryButton(String category, int index) {
    final isSelected = _selectedCategory == index; // index를 String으로 변환하여 비교
    final categoryColor = PostListScreen.categoryColors[category] ?? Colors.grey;

    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = (constraints.maxWidth / 4) - 10; // 버튼 너비 조정 (화면 너비의 1/4)
        double buttonHeight = buttonWidth * 0.5; // 버튼 높이 조정 (너비의 50%)

        return ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedCategory = isSelected ? null : index; // 선택한 카테고리의 index를 저장
              _categoryIdController.text = (index+1).toString();
              print(index);
            });
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(buttonWidth, buttonHeight),
            padding: EdgeInsets.zero,
            backgroundColor: isSelected ? categoryColor : Colors.grey[300], // 선택 상태에 따른 배경색
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white, // 선택 상태에 따른 텍스트 색상
            ),
          ),
        );
      },
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
            FocusScope.of(context).unfocus();
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
    try {
      KopoModel model = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RemediKopo(),
        ),
      );

      if (model != null && model.address != null) {
        print('선택한 주소: ${model.address}');
        setState(() {
          _isAddressSelected = true;
          _addressController.text = '${model.address}'??" ";
          // _detailedAddressController.text = '${model.buildingName}';
        });
      } else {
        print('주소가 null 값입니다.');
      }
    } catch (e) {
      print('주소 선택 중 오류 발생: $e');  // 오류 로그 출력
    }
  }

}
