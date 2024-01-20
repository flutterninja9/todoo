import 'package:flutter/material.dart';

class CreateTodoViewModel extends ChangeNotifier {
  String? _title;
  String? _content;

  String? get title => _title;
  String? get content => _content;
  bool get contentTextfieldVisible => _title != null && _title!.isNotEmpty;
  bool get canSave =>
      contentTextfieldVisible && _content != null && _content!.isNotEmpty;

  void updateTitle(String? val) {
    _title = val;
    notifyListeners();
  }

  void updateContent(String? val) {
    _content = val;
    notifyListeners();
  }
}
