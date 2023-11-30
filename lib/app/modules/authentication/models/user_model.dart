import 'dart:convert';

class User {
  final int buildNumber;
  final int createdAt;
  final String email;
  final int lastLogin;
  final String name;
  final String role;

  User({
    required this.buildNumber,
    required this.createdAt,
    required this.email,
    required this.lastLogin,
    required this.name,
    required this.role,
  });

  User copyWith({
    int? buildNumber,
    int? createdAt,
    String? email,
    int? lastLogin,
    String? name,
    String? role,
  }) =>
      User(
        buildNumber: buildNumber ?? this.buildNumber,
        createdAt: createdAt ?? this.createdAt,
        email: email ?? this.email,
        lastLogin: lastLogin ?? this.lastLogin,
        name: name ?? this.name,
        role: role ?? this.role,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        buildNumber: json["build_number"],
        createdAt: json["created_at"],
        email: json["email"],
        lastLogin: json["last_login"],
        name: json["name"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "build_number": buildNumber,
        "created_at": createdAt,
        "email": email,
        "last_login": lastLogin,
        "name": name,
        "role": role,
      };
}
