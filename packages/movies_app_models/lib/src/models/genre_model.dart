import 'package:movies_app_models/src/entities/genre.dart';

class GenreModel extends Genre {
  const GenreModel({required super.id, required super.name});

  factory GenreModel.fromJson(Map<String, dynamic> map) => GenreModel(
        id: map['id'] as int,
        name: map['name'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};
}
