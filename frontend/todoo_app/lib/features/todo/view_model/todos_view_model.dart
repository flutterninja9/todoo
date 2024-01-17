import 'package:flutter/material.dart';
import 'package:todoo_app/core/async_value/async_value.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';
import 'package:todoo_app/features/todo/repository/todos_repository.dart';

class TodoViewModel with ChangeNotifier, StateMixin {
  TodoViewModel(this._todoRepository);

  final TodosRepository _todoRepository;
  TodoResponse? _todos;
  TodoResponse? get todos => _todos;

  Future<void> fetchTodos({String? day}) async {
    try {
      setLoading();
      final todos = await _todoRepository.fetchTodos(day: day);
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
  }) async {}

  Future<void> updateTodoStatus({
    required String todoId,
    required String newStatus,
  }) async {}

  Future<void> deleteTodo({
    required String todoId,
  }) async {}
}
