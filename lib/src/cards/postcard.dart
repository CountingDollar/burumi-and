import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  int? number;

  PostCard({this.number});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.all(10),
      child: Center(
        child: Text('Post ${widget.number.toString()}'),
      )

    );
  }
}
