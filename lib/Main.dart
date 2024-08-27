import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team_burumi/src/screens/MyPageScreen.dart';
import 'package:team_burumi/src/screens/NotificationScreen.dart';
import 'package:team_burumi/src/screens/ErrandPostScreen.dart';
import 'package:team_burumi/src/screens/HomeScreen.dart';
import 'package:team_burumi/src/screens/LoginScreen.dart';
import 'package:team_burumi/src/screens/SignUpScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_burumi/src/screens/activity.dart';

import 'src/screens/chat_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return GestureDetector(
        onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
      },
      child:MaterialApp(
      title: 'Flutter Demo',
        locale: Locale('ko', 'KR'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home':(context)=> Home(),
        '/login': (context) =>  LoginPage(),
        '/signup': (context) =>  SignupPage(),
        '/alarm': (context) =>  AlarmPage(),
        '/activity': (context) =>  Activity(),
        '/errand': (context) =>  ErrandScreen(),
        '/mypage':(context)=>MyPage(),
        '/chat':(context)=> ChatScreen(),

      },
      ),
    );
  }
}