class ApiResponse {
  final int code;
  final String message;
  final Result? result;

  ApiResponse({
    required this.code,
    required this.message,
    required this.result,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      result: json['result'] != null ? Result.fromJson(json['result']) : null, // result가 null이면 null로 설정
    );
  }
}

class Result {
  final List<Post> posts;
  final int count;

  Result({
    required this.posts,
    required this.count,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    var postList = json['posts'] as List? ?? [];
    List<Post> posts = postList.map((post) => Post.fromJson(post)).toList();

    return Result(
      posts: posts,
      count: json['count']?? 0,
    );
  }
}

class Post {
  final int? id;
  final String? type;
  final String? title;
  final String? content;
  final DateTime? deletedAt;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  Post({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.deletedAt,
    this.updatedAt,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}