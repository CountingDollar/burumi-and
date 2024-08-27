import 'dart:convert';

class LoginResponse {
  final int code;
  final String message;
  final LoginResult result;

  LoginResponse({
    required this.code,
    required this.message,
    required this.result,
  });

  // JSON 데이터를 LoginResponse 객체로 변환
  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    code: json["code"],
    message: json["message"],
    result: LoginResult.fromJson(json["result"]),
  );

  // LoginResponse 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "result": result.toJson(),
  };
}

class LoginResult {
  final String tokenType;
  final String accessToken;
  final int maxAge;

  LoginResult({
    required this.tokenType,
    required this.accessToken,
    required this.maxAge,
  });

  // JSON 데이터를 LoginResult 객체로 변환
  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
    tokenType: json["token_type"],
    accessToken: json["access_token"],
    maxAge: json["max_age"],
  );

  // LoginResult 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => {
    "token_type": tokenType,
    "access_token": accessToken,
    "max_age": maxAge,
  };
}

// JSON 문자열을 LoginResponse 객체로 변환
LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

// LoginResponse 객체를 JSON 문자열로 변환
String loginResponseToJson(LoginResponse data) =>
    json.encode(data.toJson());