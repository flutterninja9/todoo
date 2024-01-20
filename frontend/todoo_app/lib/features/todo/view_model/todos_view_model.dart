import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todoo_app/core/async_value/async_value.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';
import 'package:todoo_app/features/todo/repository/todos_repository.dart';

class TodoViewModel with ChangeNotifier, StateMixin {
  TodoViewModel(this._todoRepository);

  final TodosRepository _todoRepository;
  TodoResponse? _todos;
  TodoResponse? get todos => _todos;
  String? currentFilter;

  Future<void> fetchTodos({String? day}) async {
    try {
      setLoading();
      currentFilter = day;
      final todos = await _todoRepository.fetchTodos(day: currentFilter);
      _todos = todos;
      if (todos.count == 0) {
        setEmpty();
      } else {
        setLoaded();
      }
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> addTodo({
    required String title,
    required String content,
  }) async {
    try {
      setLoading();
      final todo = Todo(
        // pending, started or completed
        status: "pending",
        title: title,
        content: content,
        id: null,
        userID: '',
        createdAt: null,
        updatedAt: null,
      );
      await _todoRepository.createTodo(todo);
      await fetchTodos(day: currentFilter);
    } catch (e) {
      log(e.toString());
      setError(e.toString());
    }
  }

  Future<void> updateTodo({
    required String id,
    String? title,
    String? content,
    String? status,
  }) async {
    try {
      setLoading();
      final todo = Todo(
        // pending, started or completed
        status: status,
        title: title,
        content: content,
        id: id,
        userID: null,
        createdAt: null,
        updatedAt: null,
      );
      await _todoRepository.updateTodo(todo);
      await fetchTodos(day: currentFilter);
    } catch (e) {
      log(e.toString());
      setError(e.toString());
    }
  }

  Future<void> deleteTodo({
    required String todoId,
  }) async {
    try {
      setLoading();
      await _todoRepository.deleteTodo(todoId);
      await fetchTodos(day: currentFilter);
    } catch (e) {
      setError(e.toString());
    }
  }
}
