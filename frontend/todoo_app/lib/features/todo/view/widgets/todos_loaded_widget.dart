import 'package:flutter/material.dart';
import 'package:todoo_app/core/design_system/app_theme.dart';
import 'package:todoo_app/features/todo/model/todo_model.dart';
import 'package:todoo_app/features/todo/view/widgets/create_todo_widget.dart';
import 'package:todoo_app/features/todo/view/widgets/todo_widget.dart';

class TodosLoadedWidget extends StatefulWidget {
  const TodosLoadedWidget({
    super.key,
    required this.todos,
    required this.isEmpty,
    required this.isError,
    required this.onCreate,
    required this.onDelete,
    required this.onUpdate,
  });

  final TodoResponse? todos;
  final bool isError;
  final bool isEmpty;

  final Function({
    required String title,
    required String content,
  }) onCreate;

  final Function({
    required String todoId,
  }) onDelete;

  final Function({
    required String id,
    String? title,
    String? content,
    String? status,
  }) onUpdate;

  @override
  State<TodosLoadedWidget> createState() => _TodosLoadedWidgetState();
}

class _TodosLoadedWidgetState extends State<TodosLoadedWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 512),
        child: Center(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.of(context).borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Todos Done",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.of(context).textColor,
                                  ),
                                ),
                                Text(
                                  widget.isEmpty
                                      ? "nothing here"
                                      : "keep it up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.of(context).textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            CircleAvatar(
                              minRadius: 50,
                              backgroundColor: AppTheme.of(context).orangeColor,
                              child: Text(
                                "${widget.todos?.completed}/${widget.todos?.count}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: CreateTodoWidget(onCreate: widget.onCreate),
              ),
              if (widget.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No Tasks",
                      style: TextStyle(
                        color: AppTheme.of(context).textColor,
                      ),
                    ),
                  ),
                )
              else if (widget.isError)
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "Oops! something went wrong",
                      style: TextStyle(
                        color: AppTheme.of(context).textColor,
                      ),
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final todo = widget.todos!.todos[index];

                    return TodoWidget(
                      key: ValueKey(index),
                      todo: todo,
                      onDelete: widget.onDelete,
                      onUpdate: widget.onUpdate,
                    );
                  },
                  itemCount: widget.todos?.count,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
