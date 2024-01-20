import 'package:flutter/material.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';

class EditTodoViewModel extends ChangeNotifier {
  Todo? _originalTodo;

  String? _title;
  String? _content;
  String? _status;

  bool _isEditing = false;

  String? get title => _title;
  String? get content => _content;
  String? get status => _status;
  bool get isEditing => _isEditing;
  bool get canUpdate =>
      (_title != _originalTodo?.title && title != null && title!.isNotEmpty) ||
      (status != _originalTodo?.status &&
          status != null &&
          status!.isNotEmpty) ||
      (content != _originalTodo?.content &&
          content != null &&
          content!.isNotEmpty);

  void init(Todo todo) {
    _originalTodo = todo;
    _title = todo.title;
    _content = todo.content;
    _status = todo.status;
  }

  void toggleEditingMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void updateTitle(String? val) {
    _title = val;
    notifyListeners();
  }

  void updateContent(String? val) {
    _content = val;
    notifyListeners();
  }

  void updateStatus(String status) {
    _status = status;
    notifyListeners();
  }
}
