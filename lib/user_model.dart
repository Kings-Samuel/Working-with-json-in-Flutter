class UserModel {
  String? username;
  String? email;
  String? imageUrl;

  UserModel({
    this.username,
    this.email,
    this.imageUrl,
  });

  static UserModel fromJson(json) => UserModel(
        username: json['username'],
        email: json['email'],
        imageUrl: json['imageUrl'],
      );
}
