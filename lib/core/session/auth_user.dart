class AuthUser {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String? token;
  final String image;

  const AuthUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.image,
  });

  String get displayName {
    final full = '${firstName.trim()} ${lastName.trim()}'.trim();
    return full.isEmpty ? username : full;
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] as num).toInt(),
      username: (json['username'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      token: (json['token'] ?? json['accessToken'])?.toString(),
      image: (json['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'token': token,
        'image': image,
      };
}
