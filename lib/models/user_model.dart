class BaseResponse {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;

  const BaseResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory BaseResponse.fromJson(Map<String, Object?> json) => BaseResponse(
        users: (json["users"] as List)
            .map(
              (e) => User.fromJson(e),
            )
            .toList(),
        total: json["total"] as int,
        skip: json["skip"] as int,
        limit: json["limit"] as int,
      );

  Map<String, Object?> toJson() => {
        "users": users.map((e) => e.toJson()).toList(),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? image;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
  });

  factory User.fromJson(Map<String, Object?> json) => User(
        id: json["id"] as int?,
        firstName: json["firstName"] as String?,
        lastName: json["lastName"] as String?,
        image: json["image"] as String?,
      );

  Map<String, Object?> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
      };
}
