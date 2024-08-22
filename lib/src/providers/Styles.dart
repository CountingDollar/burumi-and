import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const TextStyle signUpTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
const TextStyle errandPostTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold
);



const Color buttonBackgroundColor = Colors.deepPurple;



const Color errorColor = Colors.red;

const InputDecoration kTextFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1.0, //
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 2.0, // enabled 상태일 때의 선 두께
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: buttonBackgroundColor,
      width: 2.5, // 포커스 상태일 때의 선 두께
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: errorColor,
      width: 2.5, // 오류 상태일 때의 선 두께
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: errorColor,
      width: 2.5, // 포커스된 오류 상태일 때의 선 두께
    ),
  ),
  labelStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  contentPadding: EdgeInsets.only(
    top: 45,
    left: 10,
  ),
);