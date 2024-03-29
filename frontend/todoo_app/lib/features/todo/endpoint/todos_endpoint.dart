import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';

part "todos_endpoint.g.dart";

@RestApi()
abstract class TodosEndpoint {
  factory TodosEndpoint(Dio dio, {String baseUrl}) = _TodosEndpoint;

  @GET('/todos')
  Future<TodoResponse> getAllTodos(@Query("day") String? day);

  @POST('/todos')
  Future<void> createTodo(@Body() Todo todo);

  @PATCH('/todos/{id}')
  Future<void> updateTodo(@Path() String id, @Body() Todo todo);

  @DELETE('/todos/{id}')
  Future<void> deleteTodo(@Path() String id);
}
