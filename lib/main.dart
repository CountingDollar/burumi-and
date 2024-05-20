import 'package:team_burumi/screens/alarm.dart';
import 'package:team_burumi/screens/home1.dart';
import 'package:team_burumi/screens/home2.dart';
import 'package:team_burumi/screens/login.dart';
import 'package:team_burumi/screens/signup.dart';
import 'package:team_burumi/screens/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        '/home':(context)=>  home2(),
        '/profile':(context)=> profile(),
        '/login': (context) =>  LoginPage(),
        '/signup': (context) =>  SignupPage(),
        '/alarm': (context) =>  AlarmPage(),
      },
      ),
    );
  }
}