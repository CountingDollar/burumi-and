import 'package:flutter/material.dart';
import 'package:team_burumi/src/service/LogInApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
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
                    'image/Group 27.png',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(width: 260, child: emailInput()),
                  const SizedBox(height: 15),
                  SizedBox(width: 260, child: passwordInput()),
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
                      title: const Text('아이디 저장'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(width: 260, child: loginButton(context)),
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
        if (val!.isEmpty) {
          return '이메일을 입력하세요.';
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
          return '유효한 이메일 주소를 입력하세요.';
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
          return '비밀번호를 입력하세요.';
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

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_key.currentState!.validate()) return;

        String email = _emailController.text.trim();
        String password = _pwdController.text.trim();

        final authService = ApiLogin();
        final response = await authService.login(email, password);

        if (response['code'] == 2000) {
          await _storeCredentials(email, password);
          if (_isChecked) {
            await _storeCredentials(email, password, useAlternateKeys: true);
            print('아이디 및 비밀번호 저장');
          } else {
            print('아이디 및 비밀번호 저장2');
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('saved_email2');
            await prefs.remove('saved_password2');
          }
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['detail']['message'] ?? '로그인에 실패했습니다. 다시 시도하세요.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50), backgroundColor: Colors.blue),
      child: const Text(
        "로그인",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Future<void> _storeCredentials(String email, String password, {bool useAlternateKeys = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (useAlternateKeys) {
      await prefs.setString('saved_email2', email);
      await prefs.setString('saved_password2', password);
    } else {
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);
    }
    print('이메일 저장: $email');
    print('비밀번호 저장: $password');
  }
}


