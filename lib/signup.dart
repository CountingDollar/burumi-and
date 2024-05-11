import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<SignupPage> {
  int _currentStep = 0;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isPhoneNumberVaild = false;
  bool _isCodeValid = false;
  int _timeLimitSeconds = 180;
  String buttonText = '인증번호받기';

  late Timer _timer;
  final TextEditingController _controller = TextEditingController();

  bool _isFormValid() {
    return _isNameValid && _isEmailValid && _isPasswordValid;
  }

  bool _isNumFormValid() {
    return _isPhoneNumberVaild;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          // if (_isFormValid()) {
          _handleStepContinue();
          // } else {
          //   // 모든 필드가 유효하지 않은 경우에 대한 처리
          //   // 사용자에게 메시지 표시 또는 필요한 동작 수행
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text('값이 유효하지 않습니다.'),
          //     ),
          //   );
          // }
        },
        onStepCancel: () {
          _handleStepCancel();
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              if (_currentStep == 0)
                Container(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid()
                          ? Colors.green
                          : Colors.grey, // 조건에 따라 버튼의 색을 변경
                    ),
                    onPressed: details.onStepContinue,
                    child: Text('다음'),
                  ),
                ),
              if (_currentStep == 1)
                Container(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isNumFormValid()
                          ? Colors.green
                          : Colors.grey, // 조건에 따라 버튼의 색을 변경
                    ),
                    onPressed: () {
                      if (buttonText == '확인') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => completepage()),
                        );
                      } else {
                        setState(() {
                          _isCodeValid = true;
                          buttonText = '확인';
                        });
                        startTimer();
                      }
                    },
                    child: Text(buttonText),
                  ),
                ),
              if (_currentStep != 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text('이전'),
                ),
              SizedBox(width: 12),
            ],
          );
        },
        steps: [
          Step(
            title: Text('가입신청'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  '이름을 작성해주세요.',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                nameInput(),
                SizedBox(height: 30),
                Text(
                  '이메일을 작성해주세요.',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                emailInput(),
                SizedBox(height: 30),
                Text(
                  '비밀번호를 작성해주세요.',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                passwordInput(),
                SizedBox(height: 30),
                Text(
                  '비밀번호를 재입력 해주세요.',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                confirmPasswordInput(),
                SizedBox(height: 30),
              ],
            ),
            isActive: _currentStep == 0,
          ),
          Step(
            title: Text('SMS인증'),
            content: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'SMS 인증',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                phoneNumberInput(),
                SizedBox(height: 20),
                if (_isCodeValid == true)
                  Row(
                    children: [
                      Expanded(
                        child: codeInput(),
                      ),
                      SizedBox(width: 10), // 버튼과 간격 조정
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _timeLimitSeconds = 180;
                            startTimer();
                          });
                        },
                        child: Text('재요청'),
                      ),
                    ],
                  ),
              ],
            ),
            isActive: _currentStep == 1,
          ),
        ],
      ),
    );
  }

  void _handleStepContinue() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      // 최종 단계에 대한 로직을 구현합니다.
    }
  }

  void _handleStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_timeLimitSeconds < 1) {
          timer.cancel(); // 타이머 중지
        } else {
          _timeLimitSeconds -= 1; // 1초씩 감소
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 해제
    super.dispose();
  }

  Widget nameInput() {
    return Stack(
      children: [
        TextFormField(
          controller: _nameController,
          autofocus: false,
          keyboardType: TextInputType.text,
          validator: (val) {
            if (val!.isEmpty) {
              return 'The input is empty.';
            } else {
              return null;
            }
          },
          onChanged: (val) {
            // 값이 변경될 때 호출됨
            setState(() {
              _isNameValid = val.isNotEmpty; // 값이 비어 있지 않으면 유효함
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: EdgeInsets.only(
              top: 45,
              left: 10,
            ), // 상단 및 왼쪽 여백 추가
          ),
        ),
        Positioned(
          top: 3, // TextFormField 상단에 위치
          left: 15, // TextFormField 왼쪽에 위치
          child: Text(
            '잘못 입력 시 수정이 불가합니다.', // 라벨 텍스트
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey, // 라벨 색상
            ),
          ),
        ),
      ],
    );
  }

  Widget emailInput() {
    return Stack(children: [
      TextFormField(
        controller: _emailController,
        autofocus: false,
        validator: (val) {
          if (val!.isEmpty) {
            return 'The input is empty.';
          } else {
            return null;
          }
        },
        onChanged: (val) {
          // 값이 변경될 때 호출됨
          setState(() {
            _isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(val); // 값이 비어 있지 않으면 유효함
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.only(
            top: 45,
            left: 10,
          ),
        ),
      ),
      Positioned(
        top: 3, // TextFormField 상단에 위치
        left: 15, // TextFormField 왼쪽에 위치
        child: Text(
          '아이디로 사용할 이메일을 입력하세요.', // 라벨 텍스트
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey, // 라벨 색상
          ),
        ),
      ),
    ]);
  }

  Widget passwordInput() {
    return Stack(children: [
      TextFormField(
        controller: _pwdController,
        obscureText: true,
        autofocus: false,
        validator: (val) {
          if (val!.isEmpty) {
            return 'The input is empty.';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.only(
            top: 45,
            left: 10,
          ),
        ),
      ),
      Positioned(
        top: 3, // TextFormField 상단에 위치
        left: 15, // TextFormField 왼쪽에 위치
        child: Text(
          '8~16자 영문 대소문자, 숫자를 사용해주세요.', // 라벨 텍스트
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey, // 라벨 색상
          ),

        ),
      ),
    ]);
  }

  Widget confirmPasswordInput() {
    return Stack(children: [
      TextFormField(
        obscureText: true,
        autofocus: false,
        validator: (val) {
          if (val!.isEmpty) {
            return 'The input is empty.';
          } else if (val != _pwdController.text) {
            return 'Passwords do not match.';
          } else {
            return null;
          }
        },
        onChanged: (val) {
          // 값이 변경될 때 호출됨
          setState(() {
            _isPasswordValid = val.isNotEmpty && val == _pwdController.text;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.only(
            top: 45,
            left: 10,
          ),
        ),
      ),
      Positioned(
        top: 3, // TextFormField 상단에 위치
        left: 15, // TextFormField 왼쪽에 위치
        child: Text(
          '확인을 위하여 위와 동일하게 입력해주세요', // 라벨 텍스트
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey, // 라벨 색상
          ),
        ),
      ),
    ]);
  }

  TextFormField phoneNumberInput() {
    List<String> _telecomList = ['통신사', 'SKT', 'KT', 'LG U+'];
    String _selectedTelecom = '통신사';

    return TextFormField(
      controller: _phoneNumberController,
      autofocus: false,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      onChanged: (val) {
        // 값이 변경될 때 호출됨
        setState(() {
          _isPhoneNumberVaild = val.isNotEmpty;
        });
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(),
        hintText: 'Input your phone number.',
        labelText: 'Phone number',
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Container(
          // 수정된 부분
          width: 95, // 드롭다운 버튼의 너비 조절
          child: Padding(
            padding: EdgeInsets.only(right: 5, left: 10), // 버튼과 텍스트 필드 간의 간격 조절
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: InputBorder.none, // underline을 없애는 부분
              ),
              value: _selectedTelecom,
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTelecom = newValue!;
                });
              },
              items: _telecomList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                  onTap: () {
                    setState(() {
                      _selectedTelecom = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField codeInput() {
    int minutes = _timeLimitSeconds ~/ 60; // 분 단위로 변환
    int seconds = _timeLimitSeconds % 60; // 초 단위 계산
    return TextFormField(
      obscureText: true,
      autofocus: false,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '인증번호를 입력하세요',
        suffixText: '$minutes: $seconds',
        labelText: 'Verification Code',
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
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
              '회원가입 완료',
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
                  Navigator.pushNamed(context, '/login');
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
                  '로그인하러가기',
                  style: TextStyle(
                    fontSize: 18, // 텍스트 크기
                    color: Colors.grey, // 텍스트 색상
                  ),
                )),
            SizedBox(
              height: 10,
            ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BankAccountForm()));
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
                  '계좌 연결하기',
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


