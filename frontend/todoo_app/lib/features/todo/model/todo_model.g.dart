// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as String?,
      userID: json['user_id'] as String?,
      status: json['status'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userID,
      'status': instance.status,
      'title': instance.title,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

TodoResponse _$TodoResponseFromJson(Map<String, dynamic> json) => TodoResponse(
      todos: (json['data'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
    );

Map<String, dynamic> _$TodoResponseToJson(TodoResponse instance) =>
    <String, dynamic>{
      'data': instance.todos,
      'count': instance.count,
    };
