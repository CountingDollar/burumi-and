import 'package:flutter/material.dart';
import 'package:team_burumi/home.dart';

class home1 extends StatelessWidget {
  const home1 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Image.asset(
                    'image/logo.png',
                    width: 300,
                    height: 300,
                  ),
                  Text('도움이 필요할때,',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Text('움직이기 귀찮을때',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Text(
                    '부  르  미',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
        )
    );
  }
}
