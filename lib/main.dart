import 'package:team_burumi/alarm.dart';
import 'package:team_burumi/home1.dart';
import 'package:team_burumi/home2.dart';
import 'package:team_burumi/login.dart';
import 'package:team_burumi/signup.dart';
import 'package:team_burumi/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_burumi/activity.dart';
import 'package:team_burumi/home.dart';


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
      initialRoute: '/',
      routes: {
        '/': (context) => home1(),
        '/home2':(context)=>  home2(),
        '/profile':(context)=> profile(),
        '/login': (context) =>  LoginPage(),
        '/signup': (context) =>  SignupPage(),
        '/alarm': (context) =>  AlarmPage(),
        '/activity': (context) =>  Activity(),
        '/home': (context) =>  Home(),
      },
      ),
    );
  }
}