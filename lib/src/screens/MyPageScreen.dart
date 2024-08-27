import 'package:flutter/material.dart';
import 'package:team_burumi/src/cards/postcard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import '../service/JWTapi.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final JwtApi jwtApi = JwtApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '000 님',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                TextButton(
                  onPressed: () {  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditInfoPage()),
                  );},
                  child: Text(
                    '내정보 수정',
                    style: TextStyle(fontSize: 15,color:Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '부루미 포인트',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                  " 00000 p",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('충전',style:TextStyle(color:Colors.black),),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('환급 신청',style:TextStyle(color:Colors.black),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text(
                '내 활동 보기',
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '평판 보기',
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '신고 현황',
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '앱 설정',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
            ),
            SwitchListTile(
              title: Text('자동 로그인'
                  ,style: TextStyle(fontSize: 18,color: Colors.black),),
              value: true,
              onChanged: (bool value) {},
            ),
            SwitchListTile(
              title: Text('푸시 알림'
                  ,style: TextStyle(fontSize: 18,color: Colors.black),),
              value: true,
              onChanged: (bool value) {},
            ),
            SizedBox(height: 20),
            Text(
              '이용 안내',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '개인정보 처리 방침',
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '서비스 이용 약관',
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '기타',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
            ),
            TextButton(
              onPressed: () async{
                await jwtApi.removeToken();
                Navigator.pushNamed(context, '/home');
                },
              child: Text(
                '로그아웃',
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '회원 탈퇴',
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class EditInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        title: Text(
          '내정보',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/alarm');
            },
            icon: Icon(Icons.notifications, color: Colors.black),
          ),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              '000님',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '매너등급',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'EXP',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                  ),
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),

                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.3, // 예시로 70%의 경험치
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BankAccountForm())
              );},
              child: Text(
                '계좌 등록',
                style: TextStyle(fontSize: 20,color:Colors.black),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {},
              child: Text(
                '활동 배지 변경',
                style: TextStyle(fontSize: 20,color:Colors.black),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {},
              child: Text(
                '받은 평가 모음',
                style: TextStyle(fontSize: 20,color:Colors.black),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {},
              child: Text(
                '받은 후기 모음',
                style: TextStyle(fontSize: 20,color:Colors.black),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
class completepage extends StatelessWidget {
  const completepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 100,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // 원형 모양 설정
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.10), // 그림자 색상 및 투명도
                    spreadRadius: 0.001, // 그림자 확산 범위
                    blurRadius: 5, // 그림자 흐림 정도
                  ),
                ],
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.deepPurple,
                size: 70,
              ),
            ),

            Text(
              '계좌등록 완료',
              style: TextStyle(
                color: Colors.black, // 텍스트의 색상을 빨간색으로 지정
                fontSize: 40, // 텍스트의 크기 설정
                fontWeight: FontWeight.bold, // 텍스트의 굵기 설정
              ),
            ),
            Text(
              '부르미 서비스 기능을 이용해 보세요.',
              style: TextStyle(
                color: Colors.black38, // 텍스트의 색상을 빨간색으로 지정
                fontSize: 20, // 텍스트의 크기 설정
                fontWeight: FontWeight.bold, // 텍스트의 굵기 설정
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home2');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(250, 50),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 원하는 모양에 따라 조절
                  ),
                  side: BorderSide(
                    color: Colors.grey, // 경계선 색상
                    width: 1, // 경계선 두께
                  ),
                ),
                child: Text(
                  '홈으로 돌아가기',
                  style: TextStyle(
                    fontSize: 18, // 텍스트 크기
                    color: Colors.deepPurple, // 텍스트 색상
                  ),
                )),
          ])),
    );
  }
}

class BankAccountForm extends StatelessWidget {
  const BankAccountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 은행 목록
    final List<String> banks = ['농협', '카카오뱅크', '국민은행', '토스뱅크'];

    // 은행 선택값을 저장할 변수
    String? selectedBank;

    // 계좌번호 입력 필드 컨트롤러
    final TextEditingController accountNumberController = TextEditingController();

    // 이미지 파일
    File? _imageFile;

    // 이미지를 갤러리에서 선택하는 메서드
    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('계좌등록'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageFile == null
              ? Text('선택된사진이 없습니다')
              : Image.file(_imageFile!),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Select Image'),
          ),
          SizedBox(height: 60),
          DropdownButtonFormField<String>(
            value: selectedBank,
            items: banks.map((bank) {
              return DropdownMenuItem<String>(
                value: bank,
                child: Text(bank),
              );
            }).toList(),
            onChanged: (String? value) {
              // 선택된 은행을 업데이트
              selectedBank = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: accountNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '계좌번호 입력',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => completepage())
              );
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }
}
