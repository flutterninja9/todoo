// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: Todo._dateTimeFromJson(json['created_at'] as String),
      updatedAt: Todo._dateTimeFromJson(json['updated_at'] as String),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.userId,
      'status': instance.status,
      'title': instance.title,
      'content': instance.content,
      'created_at': Todo._dateTimeToJson(instance.createdAt),
      'updated_at': Todo._dateTimeToJson(instance.updatedAt),
    };
