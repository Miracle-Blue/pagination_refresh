class Post {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, Object?> json) => Post(
        userId: json["userId"] as int?,
        id: json["id"] as int?,
        title: json["title"] as String?,
        body: json["body"] as String?,
      );

  Map<String, Object?> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };

  @override
  String toString() {
    return 'Post(userId: $userId, id: $id, title: $title, body: $body)';
  }
}
