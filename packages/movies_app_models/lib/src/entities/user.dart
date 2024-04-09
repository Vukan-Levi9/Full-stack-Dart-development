import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class User extends Equatable {
  User({required this.email, required this.password, this.name, this.id});

  final String? id;
  final String? name;
  final String email;
  String password;

  @override
  List<Object?> get props => [id, name, email, password];
}
