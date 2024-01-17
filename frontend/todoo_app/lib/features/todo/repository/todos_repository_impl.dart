import 'package:todoo_app/features/todo/endpoint/todos_endpoint.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';
import 'package:todoo_app/features/todo/repository/todos_repository.dart';

class TodosRepositoryImpl implements TodosRepository {
  final TodosEndpoint _todosEndpoint;

  TodosRepositoryImpl(this._todosEndpoint);

  @override
  Future<TodoResponse> fetchTodos({String? day}) async {
    try {
      return await _todosEndpoint.getAllTodos(day);
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }
}
