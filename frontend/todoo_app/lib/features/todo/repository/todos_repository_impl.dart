import 'package:todoo_app/features/todo/endpoint/todos_endpoint.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';
import 'package:todoo_app/features/todo/repository/todos_repository.dart';

class TodosRepositoryImpl implements TodosRepository {
  final TodosEndpoint _todosEndpoint;

  TodosRepositoryImpl(this._todosEndpoint);

  @override
  Future<TodoResponse> fetchTodos({String? day}) async {
    return _todosEndpoint.getAllTodos(day);
  }

  @override
  Future<void> createTodo(Todo todo) {
    return _todosEndpoint.createTodo(todo);
  }

  @override
  Future<void> deleteTodo(String id) {
    return _todosEndpoint.deleteTodo(id);
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return _todosEndpoint.updateTodo(todo.id!, todo);
  }
}
