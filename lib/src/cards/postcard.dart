import 'package:flutter/material.dart';
import '../models/ErrandGetModel.dart'; // Delivery 클래스 포함

class PostCard extends StatelessWidget {
  final Delivery delivery; // Delivery 객체 사용
  final VoidCallback? onTap;
  final Widget? extraButton; // 추가 버튼

  const PostCard({
    Key? key,
    required this.delivery,
    this.onTap,
    this.extraButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        onTap: onTap,
        title: Text(
          delivery.summary ?? '제목 없음',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          delivery.destination ?? '목적지 없음',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: extraButton, // 추가 버튼
      ),
    );
  }
}

