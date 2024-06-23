import 'package:team_burumi/src/screens/alarm.dart';
import 'package:team_burumi/src/screens/errand-screen.dart';
import 'package:team_burumi/src/screens/home.dart';
import 'package:team_burumi/src/screens/login.dart';
import 'package:team_burumi/src/screens/sign-up.dart';
import 'package:team_burumi/src/screens/info.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_burumi/src/screens/activity.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        '/profile':(context)=> profile(),
        '/login': (context) =>  LoginPage(),
        '/signup': (context) =>  SignupPage(),
        '/alarm': (context) =>  AlarmPage(),
        '/activity': (context) =>  Activity(),
        '/errand': (context) =>  ErrandScreen(),

      },
      ),
    );
  }
}