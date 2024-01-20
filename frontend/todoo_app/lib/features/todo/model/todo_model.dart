// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

enum TodoStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('started')
  started,
  @JsonValue('completed')
  completed,
}

@JsonSerializable()
class Todo {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'user_id')
  String? userID;

  String? status;

  String? title;

  String? content;

  @JsonKey(name: 'created_at')
  DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  Todo({
    required this.id,
    required this.userID,
    required this.status,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get completed => status == "completed";

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

@JsonSerializable()
class TodoResponse {
  @JsonKey(name: "data")
  final List<Todo> todos;
  final int count;

  int get completed => todos.where((element) => element.completed).length;

  const TodoResponse({required this.todos, required this.count});

  factory TodoResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TodoResponseToJson(this);
}
