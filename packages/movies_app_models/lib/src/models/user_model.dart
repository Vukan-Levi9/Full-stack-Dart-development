import 'package:movies_app_models/movies_app_models.dart';

// ignore: must_be_immutable
class UserModel extends User {
  UserModel({
    required super.name,
    required super.email,
    required super.password,
    required super.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String,
        password: map['password'] as String,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };
}
