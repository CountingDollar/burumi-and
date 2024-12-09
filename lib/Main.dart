import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team_burumi/src/screens/MyPageScreen.dart';
import 'package:team_burumi/src/screens/NotificationScreen.dart';
import 'package:team_burumi/src/screens/ErrandPostScreen.dart';
import 'package:team_burumi/src/screens/HomeScreen.dart';
import 'package:team_burumi/src/screens/LoginScreen.dart';
import 'package:team_burumi/src/screens/SignUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_burumi/src/screens/activity.dart';

import 'src/screens/ChatListScreen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _clearPreferencesOnStart();
  await dotenv.load();
  print('앱 시작.');

  runApp(const MyApp());
}
Future<void> _clearPreferencesOnStart() async {
  print('SharedPreferences 초기화');
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
  await prefs.remove('saved_email');
  await prefs.remove('saved_password');

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        navigatorKey: navigatorKey,
      initialRoute: '/home',
      routes: {
        '/home':(context)=> Home(),
        '/login': (context) =>  LoginPage(),
        '/signup': (context) =>  SignupPage(),
        '/alarm': (context) =>  AlarmPage(),
        '/activity': (context) =>  Activity(),
        '/errand': (context) =>  ErrandScreen(),
        '/mypage':(context)=>MyPage(),
        '/chat':(context)=> ChatListScreen(),

      },
      ),
    );
  }
}