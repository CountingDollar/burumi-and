import 'package:flutter/material.dart';



class profile extends StatelessWidget {
  const profile ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }
  Widget _body(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
        },
        child: Text('로그아웃'),
      ),
    );
  }
}

