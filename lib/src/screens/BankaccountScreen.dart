import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

import 'MyPageScreen.dart';


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
