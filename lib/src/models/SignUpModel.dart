

class User {
  String name;
  String email;
  String password;
  String code;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.code

  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    password:json["password"],
    code: json["verify_code"]

  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "verify_code":code
  };
}


class ApiResponse {
  final int code;
  final String message;
  final UserResult result;

  ApiResponse({
    required this.code,
    required this.message,
    required this.result,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      result: UserResult.fromJson(json['result']),
    );
  }
}

class UserResult {
  final bool isAdmin;
  final String createdAt;
  final int id;
  final String name;
  final String phone;
  final String email;

  UserResult({
    required this.isAdmin,
    required this.createdAt,
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      isAdmin: json['is_admin'],
      createdAt: json['created_at'],
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}


class VerifyCodeResponse {
  final int code;
  final String message;
  final bool result;

  VerifyCodeResponse({
    required this.code,
    required this.message,
    required this.result,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) {
    return VerifyCodeResponse(
      code: json['code'],
      message: json['message'],
      result:json["result"],
    );
  }
}

class VerifyCodeResult {
  final String resultCode;
  final String message;
  final String msgId;
  final int successCnt;
  final int errorCnt;
  final String msgType;

  VerifyCodeResult({
    required this.resultCode,
    required this.message,
    required this.msgId,
    required this.successCnt,
    required this.errorCnt,
    required this.msgType,
  });

  factory VerifyCodeResult.fromJson(Map<String, dynamic> json) {
    return VerifyCodeResult(
      resultCode: json['result_code'],
      message: json['message'],
      msgId: json['msg_id'],
      successCnt: json['success_cnt'],
      errorCnt: json['error_cnt'],
      msgType: json['msg_type'],
    );
  }
}