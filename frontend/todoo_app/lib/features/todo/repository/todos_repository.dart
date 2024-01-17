import 'package:todoo_app/features/todo/model/todo_model.dart';

abstract class TodosRepository {
  Future<TodoResponse> fetchTodos({String? day});
}
