import 'package:flutter/material.dart';
import 'activity.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    body: Container(
      child: ElevatedButton(
        child: Text('Start Chat'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Activity()),
          );
        },
      ),
    );
    return const Placeholder();
  }
}
