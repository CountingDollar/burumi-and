import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../providers/Styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _isChecked = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'image/logo.png',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(width:260,
                    child:emailInput()),
                  const SizedBox(height: 15),
              SizedBox(width:260,
                child: passwordInput()),
                  SizedBox(
                    width: 250,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      title: Text('아이디 저장'),
                    ),
                  ),
                  const SizedBox(height: 4),
              SizedBox(width:260,
                child: loginButton()),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 아이디 찾기 기능 구현
                        },
                        child: const Text(
                          "아이디 찾기",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // 비밀번호 찾기 기능 구현
                        },
                        child: const Text(
                          "비밀번호 찾기",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup'),
                        child: const Text(
                          "회원가입",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
        controller: _emailController,
        autofocus: false,
        validator: (val) {
          //스테이트 객체만들기사용자가 알아들을수 있게
          if (val!.isEmpty) {
            return 'The input is empty.';
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(val)) {
            return 'Please enter a valid email';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: '이메일',
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
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
        hintText: '비밀번호',
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: () async {
        // 이메일과 비밀번호 가져오기
        String email = _emailController.text;
        String password = _pwdController.text;

        // API 서버로 전송
        var response = await http.post(
          Uri.parse("https://jsonplaceholder.typicode.com/users"),
          body: {'email': email, 'passsword': password},
        );

        // 응답 확인
        if (response.statusCode == 200) {
          // 로그인 성공
          // 여기에 로그인 성공 시 수행할 작업 추가
          Navigator.pushNamed(context, '/home2');
          print('Login successful');
        } else {
          // 로그인 실패
          // 여기에 로그인 실패 시 수행할 작업 추가
          //임시
          Navigator.pushNamed(context, '/home2');
          print('Login failed');
        }
      },
      style: ElevatedButton.styleFrom(
          minimumSize: Size(200, 50), // 최소 너비와 높이 설정
          backgroundColor: buttonBackgroundColor),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: const Text(
          "로그인",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
