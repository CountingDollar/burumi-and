import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:team_burumi/src/service/SignUpApi.dart';
import '../models/SignUpModel.dart';
import '../providers/Styles.dart';

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
  TextEditingController _codeInputController = TextEditingController();
  TextEditingController _confirmPwdController = TextEditingController();
  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isPhoneNumberVaild = false;
  bool _isCodeValid = false;
  String buttonText = '인증번호받기';
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

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
          _handleStepContinue();

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
                          ? buttonBackgroundColor
                          : Colors.grey, // 조건에 따라 버튼의 색을 변경
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _handleStepContinue();
                      } else {
                        // 폼이 유효하지 않은 경우
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('다시 입력해주세요.'),
                            backgroundColor: errorColor,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              if (_currentStep == 1)
                Container(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isNumFormValid()
                          ? buttonBackgroundColor
                          : Colors.grey, // 조건에 따라 버튼의 색을 변경
                    ),
                    onPressed: () async {
                      if (buttonText == '확인') {
                        String phoneNumber = _phoneNumberController.text;
                        String code = _codeInputController.text;
                        String name = _nameController.text;
                        String email = _emailController.text;
                        String password = _pwdController.text;

                        // 유저 정보 생성
                        final user = User(
                          name: name,
                          email: email,
                          password: password,
                          code: code,
                        );

                        // 인증 및 유저 생성
                        final authService = AuthService();

                        // 인증 코드 검증을 먼저 수행
                        bool isCodeValid = await authService.verifyCode(phoneNumber, code);

                        if (isCodeValid) {
                          // 인증 코드가 유효하면 유저 생성
                          bool isSignUpValid = await authService.createUser(user);

                          if (isSignUpValid) {
                            // 유저 생성 성공 후 다음 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => completepage(),
                              ),
                            );
                          } else {
                            // 유저 생성 실패 시 스낵바로 오류 메시지 출력
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('유저 생성에 실패했습니다. 다시 시도하세요.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } else {
                          // 인증 코드가 유효하지 않을 때 오류 메시지 출력
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('인증번호가 유효하지 않습니다. 다시 시도하세요.'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }else {
                        if (_isPhoneNumberVaild) {
                          setState(() {
                            _isCodeValid = true;
                            buttonText = '확인';
                          });
                          // 전화번호 전송 호출
                          String phoneNumber = _phoneNumberController.text;
                          print(phoneNumber);
                          _authService.sendVerificationCode(phoneNumber);
                        } else {
                          // 전화번호가 올바르게 선택되지 않은 경우 처리
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('전화번호를 입력학세요.'),
                              backgroundColor: Colors.red, // 배경색을 빨간색으로 설정
                            ),
                          );
                        }
                      }
                    },
                    child:
                        Text(buttonText, style: TextStyle(color: Colors.white)),
                  ),
                ),
              if (_currentStep != 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text('이전', style: TextStyle(color: Colors.black)),
                ),
              SizedBox(width: 12),
            ],
          );
        },
        steps: [
          Step(
            title: Text('가입신청'),
            content: Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    '이름을 작성해주세요.',
                    style: signUpTextStyle,
                  ),
                  SizedBox(height: 15),
                  nameInput(),
                  SizedBox(height: 30),
                  Text(
                    '이메일을 작성해주세요.',
                    style: signUpTextStyle,
                  ),
                  SizedBox(height: 15),
                  emailInput(),
                  SizedBox(height: 30),
                  Text(
                    '비밀번호를 작성해주세요.',
                    style: signUpTextStyle,
                  ),
                  SizedBox(height: 15),
                  passwordInput(),
                  SizedBox(height: 30),
                  Text(
                    '비밀번호를 재입력 해주세요.',
                    style: signUpTextStyle,
                  ),
                  SizedBox(height: 15),
                  confirmPasswordInput(),
                  SizedBox(height: 30),
                ],
              ),
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
                  style: signUpTextStyle,
                ),
                SizedBox(
                  height: 20,
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
                          if (_isPhoneNumberVaild) {
                            setState(() {
                              _isCodeValid = true;
                              buttonText = '확인';
                            });

                            // 전화번호 전송 호출
                            String phoneNumber = _phoneNumberController.text;
                            _authService.sendVerificationCode(phoneNumber);
                          }
                        },
                        child:
                            Text('재요청', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
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

  Widget nameInput() {
    return Stack(
      children: [
        TextFormField(
          controller: _nameController,
          autofocus: false,
          keyboardType: TextInputType.text,
          validator: (val) {
            if (val!.isEmpty) {
              return '이름을 입력하세요';
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
          decoration: kTextFieldDecoration,
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
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }
  Widget emailInput() {
    return Stack(children: [
      TextFormField(
          controller: _emailController,
          focusNode: _focusNode,
          validator: (val) {
            if (val!.isEmpty) {
              return '이메일을 입력하세요.';
            } else if (!_isEmailValid) {
              return '이메일이 유효하지 않습니다.';
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
          decoration: kTextFieldDecoration),
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
            return '비밀번호를 입력하세요.';
          } else {
            return null;
          }
        },
        onChanged: (val) {
          // 값이 변경될 때 호출됨
          setState(() {
            _isPasswordValid =
                val.isNotEmpty && val == _confirmPwdController.text;
          });
        },
        decoration: kTextFieldDecoration,
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
        controller: _confirmPwdController,
        obscureText: true,
        autofocus: false,
        onChanged: (val) {
          setState(() {
            _isPasswordValid = val.isNotEmpty && val == _pwdController.text;
          });
        },
        decoration: kTextFieldDecoration,
        validator: (val) {
          if (val!.isEmpty) {
            return '비밀번호를 입력하세요.';
          } else if (val != _pwdController.text) {
            return '비밀번호가 일치 하지 않습니다';
          } else {
            return null;
          }
        },
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
    return TextFormField(
      controller: _phoneNumberController,
      autofocus: false,
      validator: (val) {
        if (val!.isEmpty) {
          return '휴대폰번호를 입력하세요.';
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
        hintText: '핸드폰 번호를 입력하세요.',
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextFormField codeInput() {
    return TextFormField(
      controller: _codeInputController,
      autofocus: false,
      validator: (val) {
        if (val!.isEmpty) {
          return '값이 비어있습니다';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '인증번호를 입력하세요',
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
                color: Colors.deepPurple, // 텍스트 색상
              ),
            )),
        SizedBox(
          height: 10,
        ),
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
    final TextEditingController accountNumberController =
        TextEditingController();

    // 이미지 파일
    File? _imageFile;

    // 이미지를 갤러리에서 선택하는 메서드
    Future<void> _pickImage() async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

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
          _imageFile == null ? Text('선택된사진이 없습니다') : Image.file(_imageFile!),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => completepage()));
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }
}
