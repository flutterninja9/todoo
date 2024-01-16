import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  final String status;
  final String title;
  final String content;

  @JsonKey(
      name: 'created_at', toJson: _dateTimeToJson, fromJson: _dateTimeFromJson)
  final DateTime createdAt;

  @JsonKey(
      name: 'updated_at', toJson: _dateTimeToJson, fromJson: _dateTimeFromJson)
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.userId,
    required this.status,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  static DateTime _dateTimeFromJson(String value) => DateTime.parse(value);
  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();
}